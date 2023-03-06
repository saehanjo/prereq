create table subquery93715 as SELECT i_item_id FROM item WHERE i_category IN ('Music');

create table subquery306383 as select * from subquery93715;

create table subquery704256 as select * from subquery306383;

create table subquery194203 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery704256) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 9 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery47360 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery704256) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 9 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery77721 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery704256) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1998 AND d_moy = 9 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery133921 as with ws AS (select * from subquery77721) SELECT * FROM ws;

create table subquery123259 as with cs AS (select * from subquery47360) SELECT * FROM cs;

create table subquery52609 as with ss AS (select * from subquery194203) SELECT * FROM ss;

create table subquery90043 as with ss AS (select * from subquery194203), cs AS (select * from subquery47360), ws AS (select * from subquery77721) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery52609 UNION ALL select * from subquery123259 UNION ALL select * from subquery133921) AS tmp1 GROUP BY i_item_id ORDER BY i_item_id, total_sales;

WITH ss AS (select * from subquery194203), cs AS (select * from subquery47360), ws AS (select * from subquery77721) SELECT * FROM (select * from subquery90043) WHERE rownum <= 100;

