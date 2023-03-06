create table subquery944399 as SELECT d_week_seq FROM date_dim WHERE d_date = '1998-04-08';

create table subquery281304 as select * from subquery944399;

create table subquery477570 as select * from subquery281304;

create table subquery541786 as SELECT d_date FROM date_dim WHERE d_week_seq = (select * from subquery477570);

create table subquery930828 as select * from subquery541786;

create table subquery294188 as select * from subquery930828;

create table subquery22659 as SELECT i_item_id AS item_id, SUM(ss_ext_sales_price) AS ss_item_rev FROM store_sales, item, date_dim WHERE ss_item_sk = i_item_sk AND d_date IN (select * from subquery294188) AND ss_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery142965 as SELECT i_item_id AS item_id, SUM(cs_ext_sales_price) AS cs_item_rev FROM catalog_sales, item, date_dim WHERE cs_item_sk = i_item_sk AND d_date IN (select * from subquery294188) AND cs_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery976820 as SELECT i_item_id AS item_id, SUM(ws_ext_sales_price) AS ws_item_rev FROM web_sales, item, date_dim WHERE ws_item_sk = i_item_sk AND d_date IN (select * from subquery294188) AND ws_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery838364 as with ss_items AS (select * from subquery22659), cs_items AS (select * from subquery142965), ws_items AS (select * from subquery976820) SELECT ss_items.item_id, ss_item_rev, ss_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ss_dev, cs_item_rev, cs_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS cs_dev, ws_item_rev, ws_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ws_dev, (ss_item_rev + cs_item_rev + ws_item_rev) / 3 AS average FROM ss_items, cs_items, ws_items WHERE ss_items.item_id = cs_items.item_id AND ss_items.item_id = ws_items.item_id AND ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev ORDER BY ss_items.item_id, ss_item_rev;

WITH ss_items AS (select * from subquery22659), cs_items AS (select * from subquery142965), ws_items AS (select * from subquery976820) SELECT * FROM (select * from subquery838364) WHERE rownum <= 100;

