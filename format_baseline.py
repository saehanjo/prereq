import math
import sqlglot
import random
import re
from template_finder import QueryClusterer

import more_itertools

clusterer = QueryClusterer(input='tpcds/report_info.csv')
# clusterer = QueryClusterer(input='sqlshare')

def transformer(node):
    if isinstance(node, sqlglot.exp.Column):
        return sqlglot.parse_one("ATT")
    elif isinstance(node, sqlglot.exp.Alias) and isinstance(node.this, sqlglot.exp.Column):
        return sqlglot.parse_one("ATT")
    elif isinstance(node, sqlglot.exp.TableAlias) or isinstance(node, sqlglot.exp.Table):
        return sqlglot.parse_one("TAB")
    elif isinstance(node, sqlglot.exp.Alias) and isinstance(node.this, sqlglot.exp.Literal):
        if node.this.is_string:
            return sqlglot.parse_one("STR")
        else:
            return sqlglot.parse_one("NUM")
    elif isinstance(node, sqlglot.exp.Literal):
        if node.is_string:
            return sqlglot.parse_one("STR")
        else:
            return sqlglot.parse_one("NUM")
    return node

def remove_alias(node):
    if isinstance(node, sqlglot.exp.Alias):
        return node.this
    else:
        return node

def to_templates(sqls):
    # Add parantheses to consecutive EXCEPTs. TPC-DS.
    sqls = [' '.join(re.sub(r" (\(\(select \* from .*\) EXCEPT \(select \* from .*\))( EXCEPT \(select \* from .*\)\)) ", lambda exp: r" ({}){} ".format(exp.group(1), exp.group(2)), sql, flags=re.IGNORECASE).split()) for sql in sqls]
    templates = []
    for template_id, sql in enumerate(sqls):
        # print(template_id)
        # print(sql)
        parsed = sqlglot.parse_one(sql, read='oracle')  # read='oracle'
        transformed = parsed.transform(transformer).transform(remove_alias)
        templates.append(transformed.sql())
    return sqls, templates

report_dict = {}
for sig in clusterer.all_sigs:
    report_dict.setdefault(sig.meta.report_id, []).append(sig)

reports = []
for report_id, sigs in report_dict.items():
    sqls = [sig.sql for sig in sigs]
    # Also modifies sqls to make them parsable.
    sqls, templates = to_templates(sqls)
    reports.append({'report_id': report_id, 'sqls': sqls, 'templates': templates})

test_ratio = 0.15
test_size = math.ceil(len(reports) * test_ratio)
print(f'Test size: {test_size}')
random.seed(1)
random.shuffle(reports)

test_data = reports[:test_size]
val_data = reports[test_size:2*test_size]
train_data = reports[2*test_size:]

def write_sqls_and_templates(prefix, reports):
    with open(f'report_sqls_{prefix}.tsv', 'w') as f_s, \
        open(f'{prefix}.txt', 'w') as f_sb, open(f'{prefix}_templates.txt', 'w') as f_tb:
        for report in reports:
            report_id, sqls, templates = report['report_id'], report['sqls'], report['templates']
            for sql in sqls:
                f_s.write(f'{report_id}\t{sql}\n')
            for a, b in more_itertools.pairwise(sqls):
                # print(f'{a}\t{b}')
                f_sb.write(f'{a}\t{b}\n')
            for a, b in zip(sqls[:-1], templates[1:]):
                # print(f'{a}\t{b}')
                f_tb.write(f'{a}\t{b}\n')

write_sqls_and_templates('train', train_data)
write_sqls_and_templates('test', test_data)
write_sqls_and_templates('val', val_data)
