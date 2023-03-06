create table subquery363511 as SELECT i_manufact_id FROM item WHERE i_category IN ('Electronics');

create table subquery457815 as select * from subquery363511;

create table subquery381336 as select * from subquery457815;

create table subquery302432 as SELECT i_manufact_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery381336) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 4 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery772683 as SELECT i_manufact_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery381336) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 4 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery849717 as SELECT i_manufact_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery381336) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 4 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery104411 as with ws AS (select * from subquery849717) SELECT * FROM ws;

create table subquery365253 as with cs AS (select * from subquery772683) SELECT * FROM cs;

create table subquery422973 as with ss AS (select * from subquery302432) SELECT * FROM ss;

create table subquery60179 as with ss AS (select * from subquery302432), cs AS (select * from subquery772683), ws AS (select * from subquery849717) SELECT i_manufact_id, SUM(total_sales) AS total_sales FROM (select * from subquery422973 UNION ALL select * from subquery365253 UNION ALL select * from subquery104411) AS tmp1 GROUP BY i_manufact_id ORDER BY total_sales;

WITH ss AS (select * from subquery302432), cs AS (select * from subquery772683), ws AS (select * from subquery849717) SELECT * FROM (select * from subquery60179) WHERE rownum <= 100;

