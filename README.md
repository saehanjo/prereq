# PreReQ: Predicting Sequences of Report-Generated SQL Queries

## Quick Start

```bash
# Python 3
pip install -r requirements.txt
python query_predictor.py
```

It will run the benchmark generated from the TPC-DS queries.

## How to Integrate New Benchmarks

Create a folder that contains three `.tsv` files: `report_sqls_train.tsv`, `report_sqls_val.tsv`, `report_sqls_test.tsv`. The first column contains the report ids and the second column contains the queries. Please refer to the `tpcds/split` folder for more information. Then, you would need to change the line `type2data = load_data('tpcds/split')` in `query_predictor.py` with the path to your directory.