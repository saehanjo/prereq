create table subquery934665 as SELECT SUBSTR(i_item_desc, 1, 30) AS itemdesc, i_item_sk AS item_sk, d_date AS solddate, COUNT(*) AS cnt FROM store_sales, date_dim, item WHERE ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk AND d_year IN (1998 + 3, 1998 + 2, 1998) GROUP BY SUBSTR(i_item_desc, 1, 30), i_item_sk, d_date HAVING COUNT(*) > 4;

create table subquery639132 as SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS csales FROM store_sales, customer, date_dim WHERE ss_customer_sk = c_customer_sk AND ss_sold_date_sk = d_date_sk AND d_year IN (1998, 1998 + 1) GROUP BY c_customer_sk;

create table subquery300609 as SELECT MAX(csales) AS tpcds_cmax FROM (select * from subquery639132);

create table subquery346688 as with max_store_sales AS (select * from subquery300609) SELECT * FROM max_store_sales;

create table subquery556552 as with max_store_sales AS (select * from subquery300609) SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS ssales FROM store_sales, customer WHERE ss_customer_sk = c_customer_sk GROUP BY c_customer_sk HAVING SUM(ss_quantity * ss_sales_price) > (95 / 100.0) * (select * from subquery346688);

create table subquery667641 as with frequent_ss_items AS (select * from subquery934665) SELECT item_sk FROM frequent_ss_items;

create table subquery546796 as with frequent_ss_items AS (select * from subquery934665) select * from subquery667641;

WITH frequent_ss_items AS (select * from subquery934665), max_store_sales AS (select * from subquery300609), best_ss_customer AS (select * from subquery556552) SELECT * FROM (SELECT SUM(sales) FROM (SELECT cs_quantity * cs_list_price AS sales FROM catalog_sales, date_dim WHERE d_year = 1998 AND d_moy = 6 AND cs_sold_date_sk = d_date_sk AND cs_item_sk IN (select * from subquery546796) AND cs_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) UNION ALL SELECT ws_quantity * ws_list_price AS sales FROM web_sales, date_dim WHERE d_year = 1998 AND d_moy = 6 AND ws_sold_date_sk = d_date_sk AND ws_item_sk IN (select * from subquery546796) AND ws_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer))) WHERE rownum <= 100;

