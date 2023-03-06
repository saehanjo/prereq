create table subquery463542 as SELECT i_manufact_id FROM item WHERE i_category IN ('Electronics');

create table subquery888587 as select * from subquery463542;

create table subquery979411 as select * from subquery888587;

create table subquery730529 as SELECT i_manufact_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery979411) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 2 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery723136 as SELECT i_manufact_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery979411) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 2 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery988688 as SELECT i_manufact_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery979411) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 2 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery695990 as with ws AS (select * from subquery988688) SELECT * FROM ws;

create table subquery240811 as with cs AS (select * from subquery723136) SELECT * FROM cs;

create table subquery360461 as with ss AS (select * from subquery730529) SELECT * FROM ss;

create table subquery133972 as with ss AS (select * from subquery730529), cs AS (select * from subquery723136), ws AS (select * from subquery988688) SELECT i_manufact_id, SUM(total_sales) AS total_sales FROM (select * from subquery360461 UNION ALL select * from subquery240811 UNION ALL select * from subquery695990) AS tmp1 GROUP BY i_manufact_id ORDER BY total_sales;

WITH ss AS (select * from subquery730529), cs AS (select * from subquery723136), ws AS (select * from subquery988688) SELECT * FROM (select * from subquery133972) WHERE rownum <= 100;

