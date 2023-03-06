create table subquery942845 as SELECT i_item_id FROM item WHERE i_color IN ('chocolate');

create table subquery30952 as select * from subquery942845;

create table subquery507854 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery30952) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 1 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery325517 as SELECT i_item_id FROM item WHERE i_color IN ('chocolate', 'gainsboro');

create table subquery836424 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery325517) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 1 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery804283 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery30952) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 1 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery200352 as with ws AS (select * from subquery804283) SELECT * FROM ws;

create table subquery166749 as with cs AS (select * from subquery836424) SELECT * FROM cs;

create table subquery200122 as with ss AS (select * from subquery507854) SELECT * FROM ss;

create table subquery167971 as with ss AS (select * from subquery507854), cs AS (select * from subquery836424), ws AS (select * from subquery804283) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery200122 UNION ALL select * from subquery166749 UNION ALL select * from subquery200352) AS tmp1 GROUP BY i_item_id ORDER BY total_sales, i_item_id;

WITH ss AS (select * from subquery507854), cs AS (select * from subquery836424), ws AS (select * from subquery804283) SELECT * FROM (select * from subquery167971) WHERE rownum <= 100;

