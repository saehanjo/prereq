create table subquery784211 as SELECT d_week_seq FROM date_dim WHERE d_date = '1999-03-29';

create table subquery215245 as select * from subquery784211;

create table subquery526007 as select * from subquery215245;

create table subquery972071 as SELECT d_date FROM date_dim WHERE d_week_seq = (select * from subquery526007);

create table subquery416904 as select * from subquery972071;

create table subquery829022 as select * from subquery416904;

create table subquery388722 as SELECT i_item_id AS item_id, SUM(ss_ext_sales_price) AS ss_item_rev FROM store_sales, item, date_dim WHERE ss_item_sk = i_item_sk AND d_date IN (select * from subquery829022) AND ss_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery683758 as SELECT i_item_id AS item_id, SUM(cs_ext_sales_price) AS cs_item_rev FROM catalog_sales, item, date_dim WHERE cs_item_sk = i_item_sk AND d_date IN (select * from subquery829022) AND cs_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery743177 as SELECT i_item_id AS item_id, SUM(ws_ext_sales_price) AS ws_item_rev FROM web_sales, item, date_dim WHERE ws_item_sk = i_item_sk AND d_date IN (select * from subquery829022) AND ws_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery789719 as with ss_items AS (select * from subquery388722), cs_items AS (select * from subquery683758), ws_items AS (select * from subquery743177) SELECT ss_items.item_id, ss_item_rev, ss_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ss_dev, cs_item_rev, cs_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS cs_dev, ws_item_rev, ws_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ws_dev, (ss_item_rev + cs_item_rev + ws_item_rev) / 3 AS average FROM ss_items, cs_items, ws_items WHERE ss_items.item_id = cs_items.item_id AND ss_items.item_id = ws_items.item_id AND ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev ORDER BY ss_items.item_id, ss_item_rev;

WITH ss_items AS (select * from subquery388722), cs_items AS (select * from subquery683758), ws_items AS (select * from subquery743177) SELECT * FROM (select * from subquery789719) WHERE rownum <= 100;

