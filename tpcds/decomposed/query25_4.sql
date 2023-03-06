create table subquery765446 as SELECT SUBSTR(i_item_desc, 1, 30) AS itemdesc, i_item_sk AS item_sk, d_date AS solddate, COUNT(*) AS cnt FROM store_sales, date_dim, item WHERE ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk AND d_year IN (2000 + 1) GROUP BY SUBSTR(i_item_desc, 1, 30), i_item_sk, d_date HAVING COUNT(*) > 4;

create table subquery635155 as SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS csales FROM store_sales, customer, date_dim WHERE ss_customer_sk = c_customer_sk AND ss_sold_date_sk = d_date_sk AND d_year IN (2000 + 2, 2000 + 3, 2000 + 1, 2000) GROUP BY c_customer_sk;

create table subquery438215 as SELECT MAX(csales) AS tpcds_cmax FROM (select * from subquery635155);

create table subquery762278 as with max_store_sales AS (select * from subquery438215) SELECT * FROM max_store_sales;

create table subquery284149 as with max_store_sales AS (select * from subquery438215) SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS ssales FROM store_sales, customer WHERE ss_customer_sk = c_customer_sk GROUP BY c_customer_sk HAVING SUM(ss_quantity * ss_sales_price) > (95 / 100.0) * (select * from subquery762278);

create table subquery53218 as with frequent_ss_items AS (select * from subquery765446) SELECT item_sk FROM frequent_ss_items;

create table subquery480943 as with frequent_ss_items AS (select * from subquery765446) select * from subquery53218;

WITH frequent_ss_items AS (select * from subquery765446), max_store_sales AS (select * from subquery438215), best_ss_customer AS (select * from subquery284149) SELECT * FROM (SELECT c_last_name, c_first_name, sales FROM (SELECT c_last_name, c_first_name, SUM(cs_quantity * cs_list_price) AS sales FROM catalog_sales, customer, date_dim WHERE d_year = 2000 AND d_moy = 6 AND cs_sold_date_sk = d_date_sk AND cs_item_sk IN (select * from subquery480943) AND cs_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) AND cs_bill_customer_sk = c_customer_sk GROUP BY c_last_name, c_first_name UNION ALL SELECT c_last_name, c_first_name, SUM(ws_quantity * ws_list_price) AS sales FROM web_sales, customer, date_dim WHERE d_year = 2000 AND d_moy = 6 AND ws_sold_date_sk = d_date_sk AND ws_item_sk IN (select * from subquery480943) AND ws_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) AND ws_bill_customer_sk = c_customer_sk GROUP BY c_last_name, c_first_name) ORDER BY c_last_name, c_first_name, sales) WHERE rownum <= 100;

