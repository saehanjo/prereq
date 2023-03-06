create table subquery424197 as SELECT SUBSTR(i_item_desc, 1, 30) AS itemdesc, i_item_sk AS item_sk, d_date AS solddate, COUNT(*) AS cnt FROM store_sales, date_dim, item WHERE ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk AND d_year IN (2000 + 2, 2000) GROUP BY SUBSTR(i_item_desc, 1, 30), i_item_sk, d_date HAVING COUNT(*) > 4;

create table subquery144493 as SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS csales FROM store_sales, customer, date_dim WHERE ss_customer_sk = c_customer_sk AND ss_sold_date_sk = d_date_sk AND d_year IN (2000 + 1) GROUP BY c_customer_sk;

create table subquery840105 as SELECT MAX(csales) AS tpcds_cmax FROM (select * from subquery144493);

create table subquery83525 as with max_store_sales AS (select * from subquery840105) SELECT * FROM max_store_sales;

create table subquery122163 as with max_store_sales AS (select * from subquery840105) SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS ssales FROM store_sales, customer WHERE ss_customer_sk = c_customer_sk GROUP BY c_customer_sk HAVING SUM(ss_quantity * ss_sales_price) > (95 / 100.0) * (select * from subquery83525);

create table subquery701795 as with frequent_ss_items AS (select * from subquery424197) SELECT item_sk FROM frequent_ss_items;

create table subquery565295 as with frequent_ss_items AS (select * from subquery424197) select * from subquery701795;

WITH frequent_ss_items AS (select * from subquery424197), max_store_sales AS (select * from subquery840105), best_ss_customer AS (select * from subquery122163) SELECT * FROM (SELECT c_last_name, c_first_name, sales FROM (SELECT c_last_name, c_first_name, SUM(cs_quantity * cs_list_price) AS sales FROM catalog_sales, customer, date_dim WHERE d_year = 2000 AND d_moy = 1 AND cs_sold_date_sk = d_date_sk AND cs_item_sk IN (select * from subquery565295) AND cs_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) AND cs_bill_customer_sk = c_customer_sk GROUP BY c_last_name, c_first_name UNION ALL SELECT c_last_name, c_first_name, SUM(ws_quantity * ws_list_price) AS sales FROM web_sales, customer, date_dim WHERE d_year = 2000 AND d_moy = 1 AND ws_sold_date_sk = d_date_sk AND ws_item_sk IN (select * from subquery565295) AND ws_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) AND ws_bill_customer_sk = c_customer_sk GROUP BY c_last_name, c_first_name) ORDER BY c_last_name, c_first_name, sales) WHERE rownum <= 100;

