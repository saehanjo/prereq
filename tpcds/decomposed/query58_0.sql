create table subquery746293 as SELECT ws_sold_date_sk AS sold_date_sk, ws_bill_customer_sk AS customer_sk, ws_item_sk AS item_sk FROM web_sales;

create table subquery900670 as SELECT cs_sold_date_sk AS sold_date_sk, cs_bill_customer_sk AS customer_sk, cs_item_sk AS item_sk FROM catalog_sales;

create table subquery854181 as SELECT DISTINCT c_customer_sk, c_current_addr_sk FROM (select * from subquery900670 UNION ALL select * from subquery746293) AS cs_or_ws_sales, item, date_dim, customer WHERE sold_date_sk = d_date_sk AND item_sk = i_item_sk AND i_category = 'Music' AND i_class = 'country' AND c_customer_sk = cs_or_ws_sales.customer_sk AND d_moy = 1 AND d_year = 1999;

create table subquery33881 as SELECT DISTINCT d_month_seq + 3 FROM date_dim WHERE d_year = 1999 AND d_moy = 1;

create table subquery390230 as SELECT DISTINCT d_month_seq + 1 FROM date_dim WHERE d_year = 1999 AND d_moy = 1;

create table subquery290362 as with my_customers AS (select * from subquery854181) SELECT c_customer_sk, SUM(ss_ext_sales_price) AS revenue FROM my_customers, store_sales, customer_address, store, date_dim WHERE c_current_addr_sk = ca_address_sk AND ca_county = s_county AND ca_state = s_state AND ss_sold_date_sk = d_date_sk AND c_customer_sk = ss_customer_sk AND d_month_seq BETWEEN (select * from subquery390230) AND (select * from subquery33881) GROUP BY c_customer_sk;

WITH my_customers AS (select * from subquery854181), my_revenue AS (select * from subquery290362), segments AS (SELECT CAST((revenue / 50) AS INT) AS segment FROM my_revenue) SELECT * FROM (SELECT segment, COUNT(*) AS num_customers, segment * 50 AS segment_base FROM segments GROUP BY segment ORDER BY segment, num_customers) WHERE rownum <= 100;

