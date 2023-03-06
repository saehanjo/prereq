create table subquery595954 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1998-01-28', '1998-11-07', '1998-09-11');

create table subquery251033 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery595954);

create table subquery183081 as SELECT i_item_id AS item_id, SUM(sr_return_quantity) AS sr_item_qty FROM store_returns, item, date_dim WHERE sr_item_sk = i_item_sk AND d_date IN (select * from subquery251033) AND sr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery763709 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1998-01-28');

create table subquery426680 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery763709);

create table subquery283637 as SELECT i_item_id AS item_id, SUM(cr_return_quantity) AS cr_item_qty FROM catalog_returns, item, date_dim WHERE cr_item_sk = i_item_sk AND d_date IN (select * from subquery426680) AND cr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery626543 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1998-01-28', '1998-09-11');

create table subquery136692 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery626543);

create table subquery401667 as SELECT i_item_id AS item_id, SUM(wr_return_quantity) AS wr_item_qty FROM web_returns, item, date_dim WHERE wr_item_sk = i_item_sk AND d_date IN (select * from subquery136692) AND wr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery480936 as with sr_items AS (select * from subquery183081), cr_items AS (select * from subquery283637), wr_items AS (select * from subquery401667) SELECT sr_items.item_id, sr_item_qty, sr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS sr_dev, cr_item_qty, cr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS cr_dev, wr_item_qty, wr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS wr_dev, (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 AS average FROM sr_items, cr_items, wr_items WHERE sr_items.item_id = cr_items.item_id AND sr_items.item_id = wr_items.item_id ORDER BY sr_items.item_id, sr_item_qty;

WITH sr_items AS (select * from subquery183081), cr_items AS (select * from subquery283637), wr_items AS (select * from subquery401667) SELECT * FROM (select * from subquery480936) WHERE rownum <= 100;

