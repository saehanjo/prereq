create table subquery329462 as SELECT i_manufact_id FROM item WHERE i_category IN ('Sports');

create table subquery351766 as select * from subquery329462;

create table subquery932185 as select * from subquery351766;

create table subquery618496 as SELECT i_manufact_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery932185) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 5 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery707933 as SELECT i_manufact_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery932185) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 5 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery317523 as SELECT i_manufact_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_manufact_id IN (select * from subquery932185) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2001 AND d_moy = 5 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_manufact_id;

create table subquery726449 as with ws AS (select * from subquery317523) SELECT * FROM ws;

create table subquery710688 as with cs AS (select * from subquery707933) SELECT * FROM cs;

create table subquery100006 as with ss AS (select * from subquery618496) SELECT * FROM ss;

create table subquery14462 as with ss AS (select * from subquery618496), cs AS (select * from subquery707933), ws AS (select * from subquery317523) SELECT i_manufact_id, SUM(total_sales) AS total_sales FROM (select * from subquery100006 UNION ALL select * from subquery710688 UNION ALL select * from subquery726449) AS tmp1 GROUP BY i_manufact_id ORDER BY total_sales;

WITH ss AS (select * from subquery618496), cs AS (select * from subquery707933), ws AS (select * from subquery317523) SELECT * FROM (select * from subquery14462) WHERE rownum <= 100;

