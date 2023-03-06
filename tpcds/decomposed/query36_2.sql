create table subquery202216 as SELECT i_manufact_id FROM item WHERE i_category IN ('Electronics');

create table subquery642421 as select * from subquery202216;

create table subquery667848 as select * from subquery642421;

create table subquery696062 as SELECT i_manufact_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery667848) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 7 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery465257 as SELECT i_manufact_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery667848) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 7 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery66218 as SELECT i_manufact_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery667848) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 7 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery845567 as with ws AS (select * from subquery66218) SELECT * FROM ws;

create table subquery979510 as with cs AS (select * from subquery465257) SELECT * FROM cs;

create table subquery272341 as with ss AS (select * from subquery696062) SELECT * FROM ss;

create table subquery794454 as with ss AS (select * from subquery696062), cs AS (select * from subquery465257), ws AS (select * from subquery66218) SELECT i_manufact_id, SUM(total_sales) AS total_sales FROM (select * from subquery272341 UNION ALL select * from subquery979510 UNION ALL select * from subquery845567) AS tmp1 GROUP BY i_manufact_id ORDER BY total_sales;

WITH ss AS (select * from subquery696062), cs AS (select * from subquery465257), ws AS (select * from subquery66218) SELECT * FROM (select * from subquery794454) WHERE rownum <= 100;

