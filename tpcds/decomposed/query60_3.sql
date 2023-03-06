create table subquery272528 as SELECT i_item_id FROM item WHERE i_color IN ('light');

create table subquery707856 as select * from subquery272528;

create table subquery852147 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery707856) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 7 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery761615 as SELECT i_item_id FROM item WHERE i_color IN ('light', 'aquamarine', 'misty');

create table subquery177192 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery761615) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 7 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery512360 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery707856) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1999 AND d_moy = 7 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery537110 as with ws AS (select * from subquery512360) SELECT * FROM ws;

create table subquery171111 as with cs AS (select * from subquery177192) SELECT * FROM cs;

create table subquery314704 as with ss AS (select * from subquery852147) SELECT * FROM ss;

create table subquery655941 as with ss AS (select * from subquery852147), cs AS (select * from subquery177192), ws AS (select * from subquery512360) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery314704 UNION ALL select * from subquery171111 UNION ALL select * from subquery537110) AS tmp1 GROUP BY i_item_id ORDER BY total_sales, i_item_id;

WITH ss AS (select * from subquery852147), cs AS (select * from subquery177192), ws AS (select * from subquery512360) SELECT * FROM (select * from subquery655941) WHERE rownum <= 100;

