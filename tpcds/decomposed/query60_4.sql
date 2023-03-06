create table subquery114883 as SELECT i_item_id FROM item WHERE i_color IN ('dim', 'brown');

create table subquery652885 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery114883) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 7 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery845823 as SELECT i_item_id FROM item WHERE i_color IN ('dim');

create table subquery852147 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery845823) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 7 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery317105 as SELECT i_item_id FROM item WHERE i_color IN ('dim', 'azure');

create table subquery481213 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery317105) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 7 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -6 GROUP BY i_item_id;

create table subquery701758 as with ws AS (select * from subquery481213) SELECT * FROM ws;

create table subquery395672 as with cs AS (select * from subquery852147) SELECT * FROM cs;

create table subquery705919 as with ss AS (select * from subquery652885) SELECT * FROM ss;

create table subquery862846 as with ss AS (select * from subquery652885), cs AS (select * from subquery852147), ws AS (select * from subquery481213) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery705919 UNION ALL select * from subquery395672 UNION ALL select * from subquery701758) AS tmp1 GROUP BY i_item_id ORDER BY total_sales, i_item_id;

WITH ss AS (select * from subquery652885), cs AS (select * from subquery852147), ws AS (select * from subquery481213) SELECT * FROM (select * from subquery862846) WHERE rownum <= 100;

