import glob
import sqlglot
import duckdb
import re
import random
import pandas as pd
from pathlib import Path
from collections import Counter

DEBUG = True
RANDOMIZE_TABLE_NAME = True


def get_table_name(idx, idx_to_name):
    const_token = 'subquery'
    if RANDOMIZE_TABLE_NAME:
        name = None
        while name is None or name in idx_to_name.values():
            rand_int = random.randrange(1000000)
            name = f'{const_token}{rand_int}'
        return name
    else:
        return f'{const_token}{idx}'


def split_queries():
    for filepath in sorted(glob.glob("tpcds/query0_*.sql"), key=find_instance_idx):
        instance_idx = find_instance_idx(filepath)
        with open(filepath) as file:
            sql_all = ' '.join([line for line in file.readlines() if not line.startswith('--')])
        sqls = sql_all.split(';')
        print(len(sqls))
        for idx, sql in enumerate(sqls):
            query_idx = idx + 1
            if not sql or sql.isspace():
                print(f'Empty sql string {query_idx}')
            else:
                if query_idx == 62:
                    sql = sql.replace('order by item_id', 'order by ss_items.item_id')
                elif query_idx == 76:
                    sql = sql.replace('order by total_cnt desc, i_item_desc, w_warehouse_name, d_week_seq', 'order by total_cnt desc, i_item_desc, w_warehouse_name, d1.d_week_seq')

                lines = sql.split('\n')
                for line in lines:
                    if 'days' in line:
                        print(line)
                        # Replace except special cases when 'days' is used in column names.
                        sql = sql.replace(' days)', ')')
                file_path = f'tpcds/queries/query{query_idx}_{instance_idx}.sql'
                with open(file_path, 'w') as f:
                    f.write(f'{sql.strip()};')


def setup_tpcds():
    con = duckdb.connect(database=':memory:')
    schema_file = 'tpcds/tpcds.sql'
    with open(schema_file) as file:
        sql = ' '.join('\n'.join([line for line in file.readlines() if not line.startswith('--')]).split())
    create_table_sqls = re.findall(r'create table .*? \)', sql)
    for sql in create_table_sqls:
        con.execute(sql)
    return con


def find_query_idx(filepath):
    return int(Path(filepath).stem.replace('query', '').split('_')[0])


def find_instance_idx(filepath):
    return int(Path(filepath).stem.replace('query', '').split('_')[1])


def test_subquery(con, subquery):
    try:
        con.execute(subquery)
        return True
    except Exception as e:
        if DEBUG:
            print(subquery)
            print(e)
        return False


def to_create_sql(subquery, table_name):
    return f'create table {table_name} as {subquery}'


def drop_subquery_tables(con, idx_to_name):
    for name in idx_to_name.values():
        con.execute(f'drop table {name}')


def sort_by_with(select, with_exps):
    for idx, select_set in enumerate(with_exps):
        if select in select_set:
            return idx
    return len(with_exps)


def arrange_to_reports(instance_idxs, per_report):
    arrangement = []
    report_id = 1
    template_id = 1
    query_idx = 1
    for instance_idx in instance_idxs:
        for filepath in sorted(glob.glob(f"tpcds/decomposed/*_{instance_idx}.sql"), key=find_query_idx):
            print(filepath)
            tpcds_idx = find_query_idx(filepath)
            sqls = [sql.strip() for sql in ' '.join(Path(filepath).read_text().split()).split(';') if sql.strip()]
            for sql in sqls:
                arrangement.append((report_id, tpcds_idx, instance_idx, template_id, query_idx, sql))
                query_idx += 1
                template_id += 1
            # Increase report id.
            if tpcds_idx % per_report == 0:
                report_id += 1
        # Increase report id and reset template id when current instance ends.
        report_id += 1
        template_id = 1
    # Write reports.
    df = pd.DataFrame(arrangement, columns=['report_id', 'tpcds_id', 'instance_id', 'template_id', 'query_id', 'sql'])
    df.to_csv('tpcds/report_info.csv', index=False)

    nr_queries_per_report = Counter([report_id for report_id, *_ in arrangement])
    df = pd.DataFrame(nr_queries_per_report.items(), columns=['report_id', 'count'])
    df.to_csv('tpcds/nr_queries_per_report.csv', index=False)


# TODO: Vary the number of elements in IN list. Test baselines in related work [6].
def decompose_tpcds(instance_idxs, alter_in=False):
    temp_nr_decomposed = []
    for instance_idx in instance_idxs:
        idx_to_sql = {}
        for filepath in sorted(glob.glob(f"tpcds/queries/*_{instance_idx}.sql"), key=find_query_idx):
            print(filepath)
            query_idx = find_query_idx(filepath)
            with open(filepath) as file:
                sql = ' '.join(' '.join([line for line in file.readlines() if not line.startswith('--')]).split())
                idx_to_sql[query_idx] = sql

        con = setup_tpcds()

        for query_idx, sql in idx_to_sql.items():
            print(query_idx)
            print(f'original: {sql}')
            # Parse query.
            try:
                parsed = sqlglot.parse_one(sql, read='oracle')
            except Exception as e:
                if DEBUG:
                    print(e)
                print(f'Error when parsing query {query_idx}')
                continue
            if alter_in:
                # If set, change the number of elements in IN list.
                in_exps = list(parsed.find_all(sqlglot.exp.In))
                for in_exp in in_exps:
                    if 'expressions' in in_exp.args:
                        in_list = in_exp.args['expressions']
                        in_exp.args['expressions'] = random.sample(in_list, random.randint(1, len(in_list)))
            selects = list(parsed.find_all(sqlglot.exp.Select))
            withs = list(parsed.find_all(sqlglot.exp.With))
            assert len(withs) <= 1
            alias_to_exp = dict() if len(withs) == 0 else {as_exp.alias: str(as_exp) for as_exp in withs[0].args['expressions']}
            # Sort subqueries based on where they appear in the query.
            with_exps = [] if len(withs) == 0 else [set(as_exp.this.find_all(sqlglot.exp.Select)) for as_exp in withs[0].args['expressions']]
            selects.sort(reverse=True, key=lambda x: sort_by_with(x, with_exps))

            # Check for independent subqueries and create temporary subquery tables.
            subqueries = {}
            idx_to_name = {}
            for idx, select in enumerate(selects):
                subquery = str(select)
                if idx == 0:
                    subqueries[idx] = subquery
                else:
                    tables = [str(table) for table in select.find_all(sqlglot.exp.Table)]
                    with_sql = ', '.join([as_sql for alias, as_sql in alias_to_exp.items() if alias in tables])
                    if with_sql:
                        with_sql = f'with {with_sql} '  # Note the blank space at the end.
                    if test_subquery(con, f'{with_sql}{subquery}'):
                        name = get_table_name(idx, idx_to_name)
                        idx_to_name[idx] = name
                        subqueries = {temp_idx: prev.replace(subquery, f'select * from {name}') for temp_idx, prev in subqueries.items()}
                        alias_to_exp = {alias: prev.replace(subquery, f'select * from {name}') for alias, prev in alias_to_exp.items()}
                        subqueries[idx] = to_create_sql(f'{with_sql}{subquery}', name)
                        con.execute(subqueries[idx])

            # Drop temporary subquery tables.
            drop_subquery_tables(con, idx_to_name)
            print(f'{len(subqueries)}: {subqueries}')
            # Reverse order so that the dependency between subqueries are ordered correctly.
            sequence = dict(sorted(subqueries.items(), reverse=True))
            print(sequence)
            # Double-check that the decomposed queries are runnable.
            for idx, sql in sequence.items():
                if DEBUG:
                    print(sql)
                con.execute(sql.replace('WHERE rownum <= 100', 'limit 100'))
            drop_subquery_tables(con, idx_to_name)
            # Store the number of decomposed subqueries.
            temp_nr_decomposed.append((query_idx, instance_idx, len(sequence)))
            # Write subqueries to file.
            file_path = f'tpcds/decomposed/query{query_idx}_{instance_idx}.sql'
            with open(file_path, 'w') as f:
                for sql in sequence.values():
                    f.write(f'{sql.strip()};\n\n')

    # Write number of decomposed subqueries per TPC-DS query.
    df = pd.DataFrame(temp_nr_decomposed, columns=['tpcds_id', 'instance_id', 'count'])
    df.to_csv('tpcds/nr_decomposed_per_query.csv', index=False)


    # sql_example = ' '.join("""SELECT name, email
    #      FROM (SELECT * FROM user WHERE email IS NOT NULL)
    #      WHERE id IN (SELECT c_id FROM customer WHERE points > 5)
    # """.split())

    # find all select statements
    # for select in sqlglot.parse_one(sql_example).find_all(sqlglot.exp.Select):
    #     print(select)

    # print all column references (a and b)
    # for column in sqlglot.parse_one(sql_example).find_all(sqlglot.exp.Column):
    #     print(column.alias_or_name)

    # find all tables (x, y, z)
    # for table in sqlglot.parse_one(sql_example).find_all(sqlglot.exp.Table):
    #     print(table.name)


if __name__ == '__main__':
    # split_queries()
    # decompose_tpcds(instance_idxs=range(5), alter_in=True)
    arrange_to_reports(instance_idxs=range(5), per_report=5)
