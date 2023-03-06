create table subquery443766 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1999-11-15', '1999-10-03');

create table subquery143296 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery443766);

create table subquery665385 as SELECT i_item_id AS item_id, SUM(sr_return_quantity) AS sr_item_qty FROM store_returns, item, date_dim WHERE sr_item_sk = i_item_sk AND d_date IN (select * from subquery143296) AND sr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery821962 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1999-11-15', '1999-01-05', '1999-10-03');

create table subquery950723 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery821962);

create table subquery185074 as SELECT i_item_id AS item_id, SUM(cr_return_quantity) AS cr_item_qty FROM catalog_returns, item, date_dim WHERE cr_item_sk = i_item_sk AND d_date IN (select * from subquery950723) AND cr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery297995 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1999-01-05', '1999-11-15');

create table subquery482614 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery297995);

create table subquery71197 as SELECT i_item_id AS item_id, SUM(wr_return_quantity) AS wr_item_qty FROM web_returns, item, date_dim WHERE wr_item_sk = i_item_sk AND d_date IN (select * from subquery482614) AND wr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery311842 as with sr_items AS (select * from subquery665385), cr_items AS (select * from subquery185074), wr_items AS (select * from subquery71197) SELECT sr_items.item_id, sr_item_qty, sr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS sr_dev, cr_item_qty, cr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS cr_dev, wr_item_qty, wr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS wr_dev, (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 AS average FROM sr_items, cr_items, wr_items WHERE sr_items.item_id = cr_items.item_id AND sr_items.item_id = wr_items.item_id ORDER BY sr_items.item_id, sr_item_qty;

WITH sr_items AS (select * from subquery665385), cr_items AS (select * from subquery185074), wr_items AS (select * from subquery71197) SELECT * FROM (select * from subquery311842) WHERE rownum <= 100;

