create table subquery847022 as SELECT i_manufact_id FROM item WHERE i_category IN ('Books');

create table subquery420051 as select * from subquery847022;

create table subquery821430 as select * from subquery420051;

create table subquery453764 as SELECT i_manufact_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery821430) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 3 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery453881 as SELECT i_manufact_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery821430) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 3 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery958338 as SELECT i_manufact_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery821430) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 3 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery73673 as with ws AS (select * from subquery958338) SELECT * FROM ws;

create table subquery928282 as with cs AS (select * from subquery453881) SELECT * FROM cs;

create table subquery100847 as with ss AS (select * from subquery453764) SELECT * FROM ss;

create table subquery332081 as with ss AS (select * from subquery453764), cs AS (select * from subquery453881), ws AS (select * from subquery958338) SELECT i_manufact_id, SUM(total_sales) AS total_sales FROM (select * from subquery100847 UNION ALL select * from subquery928282 UNION ALL select * from subquery73673) AS tmp1 GROUP BY i_manufact_id ORDER BY total_sales;

WITH ss AS (select * from subquery453764), cs AS (select * from subquery453881), ws AS (select * from subquery958338) SELECT * FROM (select * from subquery332081) WHERE rownum <= 100;

