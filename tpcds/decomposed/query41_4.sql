create table subquery160177 as SELECT DISTINCT c_last_name, c_first_name, d_date FROM web_sales, date_dim, customer WHERE web_sales.ws_sold_date_sk = date_dim.d_date_sk AND web_sales.ws_bill_customer_sk = customer.c_customer_sk AND d_month_seq BETWEEN 1202 AND 1202 + 11;

create table subquery830631 as SELECT DISTINCT c_last_name, c_first_name, d_date FROM catalog_sales, date_dim, customer WHERE catalog_sales.cs_sold_date_sk = date_dim.d_date_sk AND catalog_sales.cs_bill_customer_sk = customer.c_customer_sk AND d_month_seq BETWEEN 1202 AND 1202 + 11;

create table subquery101100 as SELECT DISTINCT c_last_name, c_first_name, d_date FROM store_sales, date_dim, customer WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk AND store_sales.ss_customer_sk = customer.c_customer_sk AND d_month_seq BETWEEN 1202 AND 1202 + 11;

create table subquery211263 as SELECT COUNT(*) FROM (select * from subquery101100 INTERSECT select * from subquery830631 INTERSECT select * from subquery160177) AS hot_cust;

SELECT * FROM (select * from subquery211263) WHERE rownum <= 100;

