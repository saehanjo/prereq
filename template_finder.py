import glob
import itertools
import random
import re
import time
import more_itertools

import sqlglot
from sqlglot.diff import Keep
import pandas as pd
import numpy as np

from report_generator import setup_tpcds
from pylev import levenshtein


class QueryMeta:
    def __init__(self, row):
        if isinstance(row, tuple):
            self.report_id = row.report_id
            self.tpcds_id = row.tpcds_id
            self.instance_id = row.instance_id
            self.template_id = row.template_id
            self.query_id = row.query_id
        else:
            self.report_id = row['report_id']
            self.tpcds_id = row['tpcds_id']
            self.instance_id = row['instance_id']
            self.template_id = row['template_id']
            self.query_id = row['query_id']

    def __repr__(self):
        return str(self.__class__) + ": " + str(self.__dict__)


class QuerySignature:
    def __init__(self, sql):
        self.sql = sql
        # Parse sql to get relevant signature.
        # self.parsed = sqlglot.parse_one(sql, read='oracle')
        # self.columns = frozenset(column.alias_or_name for column in self.parsed.find_all(sqlglot.exp.Column))
        # self.has_in = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.In))
        # self.has_between = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Between))
        # self.has_exists = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Exists))
        # self.has_equals = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.EQ))
        # self.has_with = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.With))
        # self.has_case = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Case))
        # self.has_order_by = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Order))
        # self.has_group_by = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Group))
        # self.has_sum = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Sum))
        # self.has_avg = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Avg))
        # self.has_count = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Count))
        # self.has_min = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Min))
        # self.has_max = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Max))
        # self.has_distinct = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Distinct))
        # self.has_star = 0 < sum(1 for _ in self.parsed.find_all(sqlglot.exp.Star))
        # query_fragments = []
        # if self.has_in:
        #     query_fragments.append('IN')
        # if self.has_between:
        #     query_fragments.append('BETWEEN')
        # if self.has_exists:
        #     query_fragments.append('EXISTS')
        # if self.has_equals:
        #     query_fragments.append('EQUALS')
        # if self.has_with:
        #     query_fragments.append('WITH')
        # if self.has_case:
        #     query_fragments.append('CASE')
        # if self.has_order_by:
        #     query_fragments.append('ORDERBY')
        # if self.has_group_by:
        #     query_fragments.append('GROUPBY')
        # if self.has_sum:
        #     query_fragments.append('SUM')
        # if self.has_avg:
        #     query_fragments.append('AVG')
        # if self.has_count:
        #     query_fragments.append('COUNT')
        # if self.has_min:
        #     query_fragments.append('MIN')
        # if self.has_max:
        #     query_fragments.append('MAX')
        # if self.has_distinct:
        #     query_fragments.append('DISTINCT')
        # if self.has_star:
        #     query_fragments.append('STAR')
        # self.query_fragments = tuple(query_fragments)
        # Metadata which is used for evaluation.
        self.meta = None

    def __repr__(self):
        return self.sql

    def set_meta(self, meta):
        self.meta = meta


def sqlglot_diff(src, target):
    try:
        return sum(1 for action in sqlglot.diff(src, target) if not isinstance(action, Keep))
    except ValueError as e:
        print(e)
        return float('inf')


def split_sql(sql):
    # return sql.lower().split()
    # Should be used in clustering and finding closest cluster.
    # Take into account: IN list, CASE statement.
    return [word for word in re.split("(in \(.*?\))|(case .*?(?: when .*? then .*?)+? end)|\s+", sql.lower()) if word]


class QueryClusterer:
    def __init__(self, input):
        # Create query signatures.
        all_sigs = []
        if not isinstance(input, str):
            sqls_with_report_id = input
            query_id = 0
            for report_id, sql in sqls_with_report_id:
                sig = QuerySignature(sql)
                row = {'report_id': report_id,
                    'tpcds_id': -1,
                    'instance_id': -1,
                    'template_id': -1,
                    'query_id': query_id + 1}
                meta = QueryMeta(row)
                sig.set_meta(meta)
                all_sigs.append(sig)
                query_id += 1
        else:
            filepath = input
            if filepath.endswith('.csv'):
                df = pd.read_csv(filepath)
                for row in df.itertuples():
                    # if row.instance_id > 0:
                    #     continue
                    print(row.sql)
                    sig = QuerySignature(row.sql)
                    meta = QueryMeta(row)
                    sig.set_meta(meta)
                    all_sigs.append(sig)
            elif filepath.endswith('sdss') or filepath.endswith('sqlshare'):
                query_id = 0
                report_id = 0
                filenames = ['test', 'val', 'train']
                for filename in filenames:
                    df = pd.read_csv(f'{filepath}/{filename}.csv')
                    print(len(df))
                    prev_row = None
                    for row in df.itertuples():
                        if prev_row is not None:
                            if prev_row.sessionid1 == row.sessionid0 and prev_row.sqlid1 != row.sqlid0:
                                raise Exception(f'Wrong ordering: {prev_row} {row}')
                        if prev_row and prev_row.sessionid0 != row.sessionid0:
                            report_id += 1
                        sql = row.s0
                        sig = QuerySignature(sql)
                        meta_row = {'report_id': report_id + 1,
                                'tpcds_id': -1,
                                'instance_id': -1,
                                'template_id': -1,
                                'query_id': query_id + 1}
                        meta = QueryMeta(meta_row)
                        sig.set_meta(meta)
                        all_sigs.append(sig)
                        query_id += 1

                        prev_row = row
            else:
                raise ValueError(f'Wrong file type: {filepath}')
        self.all_sigs = all_sigs
        self.clusters = None
        self.cid2template = None
        self.template2cid = None
        # self.columns = sorted(set(column for sig in all_sigs for column in sig.columns))

    def to_sparse_vec(self, sig):
        return sorted(self.columns.index(column) for column in sig.columns)

    def to_vec(self, sig):
        sparse_vec = self.to_sparse_vec(sig)
        vec = np.zeros(len(self.columns))
        vec[sparse_vec] = 1
        return vec

    def to_numpy(self):
        vecs = [self.to_vec(sig) for sig in self.all_sigs]
        return np.vstack(vecs)

    def to_columns(self, sparse_vec):
        return [self.columns[idx] for idx in sparse_vec]

    def find_closest_cluster_id(self, sql):
        words = split_sql(sql)
        cid_min = None
        distance_min = None
        for cid, template in self.cid2template.items():
            target_words = split_sql(template)
            distance = levenshtein(words, target_words)
            if distance_min is None or distance < distance_min:
                distance_min = distance
                cid_min = cid
        return cid_min

    def init_cluster_ids(self):
        self.cid2template = {}
        self.template2cid = {}
        for temp_cid, (template, cluster) in enumerate(self.clusters.items()):
            cid = temp_cid + 1
            for sig in cluster:
                sig.meta.estimated_template_id = cid
            self.cid2template[cid] = template
            self.template2cid[template] = cid

    def format_keys_as_templates(self, temp_clusters):
        clusters = {}
        for sigs in temp_clusters.values():
            template = split_sql(sigs[0].sql)
            for sig in sigs:
                words = split_sql(sig.sql)
                for idx in range(max(len(template), len(words))):
                    if idx >= len(template):
                        template.append('[PH]')
                    elif idx >= len(words):
                        template[idx] = '[PH]'
                    else:
                        if template[idx] != words[idx]:
                            template[idx] = '[PH]'
            template_sql = ' '.join(template)
            print(f'{len(sigs)}\t{template_sql}')
            if template_sql in clusters:
                clusters[template_sql].extend(sigs)
            else:
                clusters[template_sql] = sigs
        return clusters

    def cluster_by_sqlglot(self, max_diff=20):
        clusters = {}
        print(f'Clustering {len(self.all_sigs)} elements...')
        start_time = time.time()
        for idx, sig in enumerate(self.all_sigs):
            if idx % 100 == 0:
                print(f'{idx}: {time.time() - start_time}')
            pos_cluster_keys = [key for key in clusters.keys()
                                if max_diff > sqlglot_diff(sig.parsed, self.all_sigs[key].parsed)]
            nr_pos = len(pos_cluster_keys)
            if nr_pos == 0:
                clusters[idx] = [sig]
            else:
                key = pos_cluster_keys[0]
                clusters[key].append(sig)
        self.clusters = self.format_keys_as_templates(clusters)

        # target_sig = all_sigs[3]
        # len2sigs = {}
        # for sig in all_sigs:
        #     diff_exp = sqlglot.diff(target_sig.parsed, sig.parsed)
        #     len_diff = sum(1 for action in sqlglot.diff(target_sig.parsed, sig.parsed) if not isinstance(action, Keep))
        #     len2sigs.setdefault(len_diff, []).append(sig)
        # for len_diff, sigs in sorted(len2sigs.items()):
        #     if len_diff < 50:
        #         print(f'{len_diff}: {len(sigs)} {sigs}')
        #         diff_exp = sqlglot.diff(target_sig.parsed, sigs[0].parsed)
        #         compared = sigs[0].parsed
        
    def cluster_by_levenshtein_fast(self, max_ratio=0.1):
        # Keep track of distances between clusters.
        # Skip comparison against clusters with too high lower bound.
        pass

    def cluster_by_levenshtein(self, max_ratio=0.1):
        clusters = {}
        print(f'Clustering {len(self.all_sigs)} elements...')
        start_time = time.time()
        for idx, sig in enumerate(self.all_sigs):
            if idx % 100 == 0:
                print(f'{idx}: {time.time() - start_time}')
            words = split_sql(sig.sql)
            nr_words = len(words)
            pos_cluster_keys = [sql for sql, other_words in
                                ((sql, split_sql(sql)) for sql in clusters.keys())
                                if max_ratio > (levenshtein(words, other_words) / (nr_words + len(other_words)))]
            nr_pos = len(pos_cluster_keys)
            if nr_pos == 0:
                clusters[sig.sql] = [sig]
            else:
                key = pos_cluster_keys[0]
                clusters[key].append(sig)
        self.clusters = self.format_keys_as_templates(clusters)

    def cluster_by_levenshtein_slow(self, max_ratio=0.1):
        clusters = []
        print(f'Clustering {len(self.all_sigs)} elements...')
        start_time = time.time()
        for idx, sig in enumerate(self.all_sigs):
            if idx % 100 == 0:
                print(f'{idx}: {time.time() - start_time}')
            words = split_sql(sig.sql)
            nr_words = len(words)
            pos_clusters = [cluster for cluster in clusters
                            if any(max_ratio > (levenshtein(words, other_words) / (nr_words + len(other_words)))
                                   for other_words in (split_sql(other_sig.sql) for other_sig in cluster))]
            nr_pos = len(pos_clusters)
            if nr_pos == 0:
                clusters.append([sig])
            elif nr_pos > 1:
                # Merge clusters.
                flat_list = [item for sublist in pos_clusters for item in sublist]
                flat_list.append(sig)
                clusters = [cluster for cluster in clusters
                            if not any(max_ratio > (levenshtein(words, other_words) / (nr_words + len(other_words)))
                                       for other_words in (split_sql(other_sig.sql) for other_sig in cluster))]
                clusters.append(flat_list)
                # raise Exception(f'Too many possible clusters for {sig}: {pos_clusters}')
            else:
                pos_clusters[0].append(sig)
        self.clusters = self.format_keys_as_templates(clusters)

    def cluster_by_column_set(self):
        clusters = {}
        for sig in self.all_sigs:
            clusters.setdefault(sig.columns, []).append(sig)
        self.clusters = self.format_keys_as_templates(clusters)

    def cluster_by_column_set_query_fragments(self):
        clusters = {}
        for sig in self.all_sigs:
            clusters.setdefault((sig.query_fragments, sig.columns), []).append(sig)
        self.clusters = self.format_keys_as_templates(clusters)

    # def group_by_column_set(self, tolerance):
    #     assert tolerance >= 0
    #     if tolerance == 0:
    #         return self.group_by_column_set_no_tolerance()
    #     # List of tuples (key, value) where the key is a set of column sets.
    #     groups = []
    #     for sig in self.all_sigs:
    #         is_added = False
    #         temp_tolerance = 0 if len(sig.columns) <= tolerance else tolerance
    #         # Search for groups within increasing tolerance.
    #         for inc_tolerance in range(0, temp_tolerance + 1):
    #             for key, sigs in groups:
    #                 if any(len(column_set ^ sig.columns) <= inc_tolerance for column_set in key):
    #                     key.add(sig.columns)
    #                     sigs.append(sig)
    #                     is_added = True
    #                     break
    #             if is_added:
    #                 break
    #         if not is_added:
    #             groups.append(({sig.columns}, [sig]))
    #     return groups


if __name__ == '__main__':
    clusterer = QueryClusterer(filepath='tpcds/report_info.csv')
    # Group queries by column set.
    # clusters = clusterer.cluster_by_column_set()
    clusters = clusterer.cluster_by_column_set_query_fragments()
    # Correct info per cluster.
    column_cluster_info = []
    tpcds_to_queries = {}
    for key, sigs in clusters.items():
        nr_queries = len(sigs)
        tpcds_ids = set(sig.meta.tpcds_id for sig in sigs)
        nr_tpcds_ids = len(tpcds_ids)
        template_ids = set(sig.meta.template_id for sig in sigs)
        nr_template_ids = len(template_ids)
        # column_names = key
        # column_names = set(column.alias_or_name for column in key)
        row = (nr_queries, nr_tpcds_ids, tpcds_ids, nr_template_ids, template_ids, key)
        print(f'{row}')
        column_cluster_info.append(row)
        key = (nr_queries, nr_tpcds_ids, nr_template_ids)
        tpcds_to_queries[key] = tpcds_to_queries.get(key, 0) + 1
    pd.DataFrame(sorted(column_cluster_info, key=lambda x: (x[1], -x[0], x[2])),
                 columns=['nr_queries', 'nr_tpcds_ids', 'tpcds_ids', 'nr_template_ids', 'template_ids', 'key']) \
        .to_csv('tpcds/cluster.csv', index=False)
    pd.DataFrame(sorted(((*key, value) for key, value in tpcds_to_queries.items()), key=lambda x: (x[1], -x[0])),
                 columns=['nr_queries', 'nr_tpcds_ids', 'nr_template_ids', 'count']) \
        .to_csv('tpcds/cluster_tpcds.csv', index=False)

    # con = setup_tpcds()
    # for sig in all_sigs:
    #     print(sig.sql)
    #     sql = sig.sql.lower()
    #     if sql.startswith('create table '):
    #         sql = sql[sql.index(' as ') + 4:]
    #     physical_plan = con.execute(f"DESCRIBE {sql}").fetchall()
    # for tup in physical_plan:
    #     print(tup[0])
    #     print(tup[1])
