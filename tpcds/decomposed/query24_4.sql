create table subquery823007 as SELECT SUBSTR(i_item_desc, 1, 30) AS itemdesc, i_item_sk AS item_sk, d_date AS solddate, COUNT(*) AS cnt FROM store_sales, date_dim, item WHERE ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk AND d_year IN (2000 + 2) GROUP BY SUBSTR(i_item_desc, 1, 30), i_item_sk, d_date HAVING COUNT(*) > 4;

create table subquery619536 as SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS csales FROM store_sales, customer, date_dim WHERE ss_customer_sk = c_customer_sk AND ss_sold_date_sk = d_date_sk AND d_year IN (2000 + 2, 2000 + 3) GROUP BY c_customer_sk;

create table subquery920332 as SELECT MAX(csales) AS tpcds_cmax FROM (select * from subquery619536);

create table subquery86594 as with max_store_sales AS (select * from subquery920332) SELECT * FROM max_store_sales;

create table subquery370088 as with max_store_sales AS (select * from subquery920332) SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS ssales FROM store_sales, customer WHERE ss_customer_sk = c_customer_sk GROUP BY c_customer_sk HAVING SUM(ss_quantity * ss_sales_price) > (95 / 100.0) * (select * from subquery86594);

create table subquery676444 as with frequent_ss_items AS (select * from subquery823007) SELECT item_sk FROM frequent_ss_items;

create table subquery110144 as with frequent_ss_items AS (select * from subquery823007) select * from subquery676444;

WITH frequent_ss_items AS (select * from subquery823007), max_store_sales AS (select * from subquery920332), best_ss_customer AS (select * from subquery370088) SELECT * FROM (SELECT SUM(sales) FROM (SELECT cs_quantity * cs_list_price AS sales FROM catalog_sales, date_dim WHERE d_year = 2000 AND d_moy = 6 AND cs_sold_date_sk = d_date_sk AND cs_item_sk IN (select * from subquery110144) AND cs_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) UNION ALL SELECT ws_quantity * ws_list_price AS sales FROM web_sales, date_dim WHERE d_year = 2000 AND d_moy = 6 AND ws_sold_date_sk = d_date_sk AND ws_item_sk IN (select * from subquery110144) AND ws_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer))) WHERE rownum <= 100;

