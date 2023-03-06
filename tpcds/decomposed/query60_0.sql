create table subquery289126 as SELECT i_item_id FROM item WHERE i_color IN ('pink', 'powder');

create table subquery211065 as select * from subquery289126;

create table subquery616824 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery211065) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 3 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery693455 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery211065) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 3 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery200603 as SELECT i_item_id FROM item WHERE i_color IN ('pink', 'orchid');

create table subquery9781 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery200603) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 3 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery2704 as with ws AS (select * from subquery9781) SELECT * FROM ws;

create table subquery234031 as with cs AS (select * from subquery693455) SELECT * FROM cs;

create table subquery50522 as with ss AS (select * from subquery616824) SELECT * FROM ss;

create table subquery98498 as with ss AS (select * from subquery616824), cs AS (select * from subquery693455), ws AS (select * from subquery9781) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery50522 UNION ALL select * from subquery234031 UNION ALL select * from subquery2704) AS tmp1 GROUP BY i_item_id ORDER BY total_sales, i_item_id;

WITH ss AS (select * from subquery616824), cs AS (select * from subquery693455), ws AS (select * from subquery9781) SELECT * FROM (select * from subquery98498) WHERE rownum <= 100;

