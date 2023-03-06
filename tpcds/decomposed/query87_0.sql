create table subquery810812 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('2001-11-16', '2001-07-13', '2001-09-10');

create table subquery268025 as select * from subquery810812;

create table subquery796229 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery268025);

create table subquery909375 as select * from subquery796229;

create table subquery333460 as SELECT i_item_id AS item_id, SUM(sr_return_quantity) AS sr_item_qty FROM store_returns, item, date_dim WHERE sr_item_sk = i_item_sk AND d_date IN (select * from subquery909375) AND sr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery230396 as SELECT i_item_id AS item_id, SUM(cr_return_quantity) AS cr_item_qty FROM catalog_returns, item, date_dim WHERE cr_item_sk = i_item_sk AND d_date IN (select * from subquery909375) AND cr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery426596 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('2001-07-13');

create table subquery695735 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery426596);

create table subquery782896 as SELECT i_item_id AS item_id, SUM(wr_return_quantity) AS wr_item_qty FROM web_returns, item, date_dim WHERE wr_item_sk = i_item_sk AND d_date IN (select * from subquery695735) AND wr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery274723 as with sr_items AS (select * from subquery333460), cr_items AS (select * from subquery230396), wr_items AS (select * from subquery782896) SELECT sr_items.item_id, sr_item_qty, sr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS sr_dev, cr_item_qty, cr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS cr_dev, wr_item_qty, wr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS wr_dev, (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 AS average FROM sr_items, cr_items, wr_items WHERE sr_items.item_id = cr_items.item_id AND sr_items.item_id = wr_items.item_id ORDER BY sr_items.item_id, sr_item_qty;

WITH sr_items AS (select * from subquery333460), cr_items AS (select * from subquery230396), wr_items AS (select * from subquery782896) SELECT * FROM (select * from subquery274723) WHERE rownum <= 100;

