create table subquery250426 as SELECT i_item_id FROM item WHERE i_category IN ('Jewelry');

create table subquery678739 as select * from subquery250426;

create table subquery550993 as select * from subquery678739;

create table subquery131888 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery550993) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 10 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery516682 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery550993) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 10 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery183957 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery550993) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy = 10 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery612549 as with ws AS (select * from subquery183957) SELECT * FROM ws;

create table subquery978861 as with cs AS (select * from subquery516682) SELECT * FROM cs;

create table subquery807249 as with ss AS (select * from subquery131888) SELECT * FROM ss;

create table subquery317998 as with ss AS (select * from subquery131888), cs AS (select * from subquery516682), ws AS (select * from subquery183957) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery807249 UNION ALL select * from subquery978861 UNION ALL select * from subquery612549) AS tmp1 GROUP BY i_item_id ORDER BY i_item_id, total_sales;

WITH ss AS (select * from subquery131888), cs AS (select * from subquery516682), ws AS (select * from subquery183957) SELECT * FROM (select * from subquery317998) WHERE rownum <= 100;

