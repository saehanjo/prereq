create table subquery935688 as SELECT d_week_seq FROM date_dim WHERE d_date = '2001-07-13';

create table subquery214826 as select * from subquery935688;

create table subquery439148 as select * from subquery214826;

create table subquery903 as SELECT d_date FROM date_dim WHERE d_week_seq = (select * from subquery439148);

create table subquery480792 as select * from subquery903;

create table subquery120000 as select * from subquery480792;

create table subquery118651 as SELECT i_item_id AS item_id, SUM(ss_ext_sales_price) AS ss_item_rev FROM store_sales, item, date_dim WHERE ss_item_sk = i_item_sk AND d_date IN (select * from subquery120000) AND ss_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery592753 as SELECT i_item_id AS item_id, SUM(cs_ext_sales_price) AS cs_item_rev FROM catalog_sales, item, date_dim WHERE cs_item_sk = i_item_sk AND d_date IN (select * from subquery120000) AND cs_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery943325 as SELECT i_item_id AS item_id, SUM(ws_ext_sales_price) AS ws_item_rev FROM web_sales, item, date_dim WHERE ws_item_sk = i_item_sk AND d_date IN (select * from subquery120000) AND ws_sold_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery618931 as with ss_items AS (select * from subquery118651), cs_items AS (select * from subquery592753), ws_items AS (select * from subquery943325) SELECT ss_items.item_id, ss_item_rev, ss_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ss_dev, cs_item_rev, cs_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS cs_dev, ws_item_rev, ws_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ws_dev, (ss_item_rev + cs_item_rev + ws_item_rev) / 3 AS average FROM ss_items, cs_items, ws_items WHERE ss_items.item_id = cs_items.item_id AND ss_items.item_id = ws_items.item_id AND ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev ORDER BY ss_items.item_id, ss_item_rev;

WITH ss_items AS (select * from subquery118651), cs_items AS (select * from subquery592753), ws_items AS (select * from subquery943325) SELECT * FROM (select * from subquery618931) WHERE rownum <= 100;

