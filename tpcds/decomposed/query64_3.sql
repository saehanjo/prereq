create table subquery322384 as SELECT i_item_id FROM item WHERE i_category IN ('Shoes');

create table subquery356266 as select * from subquery322384;

create table subquery138301 as select * from subquery356266;

create table subquery994553 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery138301) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 10 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery413042 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery138301) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 10 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery854540 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery138301) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 10 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery211323 as with ws AS (select * from subquery854540) SELECT * FROM ws;

create table subquery86758 as with cs AS (select * from subquery413042) SELECT * FROM cs;

create table subquery364217 as with ss AS (select * from subquery994553) SELECT * FROM ss;

create table subquery248762 as with ss AS (select * from subquery994553), cs AS (select * from subquery413042), ws AS (select * from subquery854540) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery364217 UNION ALL select * from subquery86758 UNION ALL select * from subquery211323) AS tmp1 GROUP BY i_item_id ORDER BY i_item_id, total_sales;

WITH ss AS (select * from subquery994553), cs AS (select * from subquery413042), ws AS (select * from subquery854540) SELECT * FROM (select * from subquery248762) WHERE rownum <= 100;

