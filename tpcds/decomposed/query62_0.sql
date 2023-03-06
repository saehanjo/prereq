create table subquery190665 as SELECT d_week_seq FROM date_dim WHERE d_date = '2001-06-16';

create table subquery198275 as select * from subquery190665;

create table subquery48994 as select * from subquery198275;

create table subquery548553 as SELECT d_date FROM date_dim WHERE d_week_seq = (select * from subquery48994);

create table subquery858722 as select * from subquery548553;

create table subquery905 as select * from subquery858722;

create table subquery483621 as SELECT i_item_id AS item_id, SUM(ss_ext_sales_price) AS ss_item_rev FROM store_sales, item, date_dim WHERE ss_item_sk = i_item_sk AND d_date IN (select * from subquery905) AND ss_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery482229 as SELECT i_item_id AS item_id, SUM(cs_ext_sales_price) AS cs_item_rev FROM catalog_sales, item, date_dim WHERE cs_item_sk = i_item_sk AND d_date IN (select * from subquery905) AND cs_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery420304 as SELECT i_item_id AS item_id, SUM(ws_ext_sales_price) AS ws_item_rev FROM web_sales, item, date_dim WHERE ws_item_sk = i_item_sk AND d_date IN (select * from subquery905) AND ws_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery237977 as with ss_items AS (select * from subquery483621), cs_items AS (select * from subquery482229), ws_items AS (select * from subquery420304) SELECT ss_items.item_id, ss_item_rev, ss_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ss_dev, cs_item_rev, cs_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS cs_dev, ws_item_rev, ws_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ws_dev, (ss_item_rev + cs_item_rev + ws_item_rev) / 3 AS average FROM ss_items, cs_items, ws_items WHERE ss_items.item_id = cs_items.item_id AND ss_items.item_id = ws_items.item_id AND ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev ORDER BY ss_items.item_id, ss_item_rev;

WITH ss_items AS (select * from subquery483621), cs_items AS (select * from subquery482229), ws_items AS (select * from subquery420304) SELECT * FROM (select * from subquery237977) WHERE rownum <= 100;

