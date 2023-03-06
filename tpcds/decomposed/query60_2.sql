create table subquery586972 as SELECT i_item_id FROM item WHERE i_color IN ('maroon');

create table subquery673236 as select * from subquery586972;

create table subquery701454 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery673236) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2002 AND d_moy = 1 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery151359 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery673236) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2002 AND d_moy = 1 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery285971 as SELECT i_item_id FROM item WHERE i_color IN ('rosy', 'papaya', 'maroon');

create table subquery452090 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery285971) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2002 AND d_moy = 1 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery717324 as with ws AS (select * from subquery452090) SELECT * FROM ws;

create table subquery6903 as with cs AS (select * from subquery151359) SELECT * FROM cs;

create table subquery874299 as with ss AS (select * from subquery701454) SELECT * FROM ss;

create table subquery859994 as with ss AS (select * from subquery701454), cs AS (select * from subquery151359), ws AS (select * from subquery452090) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery874299 UNION ALL select * from subquery6903 UNION ALL select * from subquery717324) AS tmp1 GROUP BY i_item_id ORDER BY total_sales, i_item_id;

WITH ss AS (select * from subquery701454), cs AS (select * from subquery151359), ws AS (select * from subquery452090) SELECT * FROM (select * from subquery859994) WHERE rownum <= 100;

