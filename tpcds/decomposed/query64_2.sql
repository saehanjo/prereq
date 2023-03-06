create table subquery817938 as SELECT i_item_id FROM item WHERE i_category IN ('Music');

create table subquery131392 as select * from subquery817938;

create table subquery404361 as select * from subquery131392;

create table subquery755721 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery404361) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 9 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery475893 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery404361) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 9 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery588102 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery404361) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 9 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery193519 as with ws AS (select * from subquery588102) SELECT * FROM ws;

create table subquery128402 as with cs AS (select * from subquery475893) SELECT * FROM cs;

create table subquery637544 as with ss AS (select * from subquery755721) SELECT * FROM ss;

create table subquery831617 as with ss AS (select * from subquery755721), cs AS (select * from subquery475893), ws AS (select * from subquery588102) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery637544 UNION ALL select * from subquery128402 UNION ALL select * from subquery193519) AS tmp1 GROUP BY i_item_id ORDER BY i_item_id, total_sales;

WITH ss AS (select * from subquery755721), cs AS (select * from subquery475893), ws AS (select * from subquery588102) SELECT * FROM (select * from subquery831617) WHERE rownum <= 100;

