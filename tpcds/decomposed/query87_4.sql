create table subquery205461 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1998-08-07', '1998-11-16', '1998-02-24');

create table subquery316596 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery205461);

create table subquery31750 as SELECT i_item_id AS item_id, SUM(sr_return_quantity) AS sr_item_qty FROM store_returns, item, date_dim WHERE sr_item_sk = i_item_sk AND d_date IN (select * from subquery316596) AND sr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery677070 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1998-11-16', '1998-02-24');

create table subquery38305 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery677070);

create table subquery212880 as SELECT i_item_id AS item_id, SUM(cr_return_quantity) AS cr_item_qty FROM catalog_returns, item, date_dim WHERE cr_item_sk = i_item_sk AND d_date IN (select * from subquery38305) AND cr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery196846 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1998-08-07', '1998-11-16');

create table subquery345382 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery196846);

create table subquery948096 as SELECT i_item_id AS item_id, SUM(wr_return_quantity) AS wr_item_qty FROM web_returns, item, date_dim WHERE wr_item_sk = i_item_sk AND d_date IN (select * from subquery345382) AND wr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery89970 as with sr_items AS (select * from subquery31750), cr_items AS (select * from subquery212880), wr_items AS (select * from subquery948096) SELECT sr_items.item_id, sr_item_qty, sr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS sr_dev, cr_item_qty, cr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS cr_dev, wr_item_qty, wr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS wr_dev, (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 AS average FROM sr_items, cr_items, wr_items WHERE sr_items.item_id = cr_items.item_id AND sr_items.item_id = wr_items.item_id ORDER BY sr_items.item_id, sr_item_qty;

WITH sr_items AS (select * from subquery31750), cr_items AS (select * from subquery212880), wr_items AS (select * from subquery948096) SELECT * FROM (select * from subquery89970) WHERE rownum <= 100;

