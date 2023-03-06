create table subquery587996 as SELECT SUBSTR(i_item_desc, 1, 30) AS itemdesc, i_item_sk AS item_sk, d_date AS solddate, COUNT(*) AS cnt FROM store_sales, date_dim, item WHERE ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk AND d_year IN (1998 + 3) GROUP BY SUBSTR(i_item_desc, 1, 30), i_item_sk, d_date HAVING COUNT(*) > 4;

create table subquery468284 as SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS csales FROM store_sales, customer, date_dim WHERE ss_customer_sk = c_customer_sk AND ss_sold_date_sk = d_date_sk AND d_year IN (1998 + 3, 1998, 1998 + 2) GROUP BY c_customer_sk;

create table subquery529521 as SELECT MAX(csales) AS tpcds_cmax FROM (select * from subquery468284);

create table subquery278608 as with max_store_sales AS (select * from subquery529521) SELECT * FROM max_store_sales;

create table subquery651539 as with max_store_sales AS (select * from subquery529521) SELECT c_customer_sk, SUM(ss_quantity * ss_sales_price) AS ssales FROM store_sales, customer WHERE ss_customer_sk = c_customer_sk GROUP BY c_customer_sk HAVING SUM(ss_quantity * ss_sales_price) > (95 / 100.0) * (select * from subquery278608);

create table subquery892035 as with frequent_ss_items AS (select * from subquery587996) SELECT item_sk FROM frequent_ss_items;

create table subquery447059 as with frequent_ss_items AS (select * from subquery587996) select * from subquery892035;

WITH frequent_ss_items AS (select * from subquery587996), max_store_sales AS (select * from subquery529521), best_ss_customer AS (select * from subquery651539) SELECT * FROM (SELECT c_last_name, c_first_name, sales FROM (SELECT c_last_name, c_first_name, SUM(cs_quantity * cs_list_price) AS sales FROM catalog_sales, customer, date_dim WHERE d_year = 1998 AND d_moy = 4 AND cs_sold_date_sk = d_date_sk AND cs_item_sk IN (select * from subquery447059) AND cs_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) AND cs_bill_customer_sk = c_customer_sk GROUP BY c_last_name, c_first_name UNION ALL SELECT c_last_name, c_first_name, SUM(ws_quantity * ws_list_price) AS sales FROM web_sales, customer, date_dim WHERE d_year = 1998 AND d_moy = 4 AND ws_sold_date_sk = d_date_sk AND ws_item_sk IN (select * from subquery447059) AND ws_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer) AND ws_bill_customer_sk = c_customer_sk GROUP BY c_last_name, c_first_name) ORDER BY c_last_name, c_first_name, sales) WHERE rownum <= 100;

