create table subquery193215 as SELECT ss_customer_sk AS customer_sk, ss_item_sk AS item_sk FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1224 AND 1224 + 11 GROUP BY ss_customer_sk, ss_item_sk;

create table subquery888092 as SELECT cs_bill_customer_sk AS customer_sk, cs_item_sk AS item_sk FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1224 AND 1224 + 11 GROUP BY cs_bill_customer_sk, cs_item_sk;

create table subquery145078 as with ssci AS (select * from subquery193215), csci AS (select * from subquery888092) SELECT SUM(CASE WHEN NOT ssci.customer_sk IS NULL AND csci.customer_sk IS NULL THEN 1 ELSE 0 END) AS store_only, SUM(CASE WHEN ssci.customer_sk IS NULL AND NOT csci.customer_sk IS NULL THEN 1 ELSE 0 END) AS catalog_only, SUM(CASE WHEN NOT ssci.customer_sk IS NULL AND NOT csci.customer_sk IS NULL THEN 1 ELSE 0 END) AS store_and_catalog FROM ssci FULL OUTER JOIN csci ON (ssci.customer_sk = csci.customer_sk AND ssci.item_sk = csci.item_sk);

WITH ssci AS (select * from subquery193215), csci AS (select * from subquery888092) SELECT * FROM (select * from subquery145078) WHERE rownum <= 100;

