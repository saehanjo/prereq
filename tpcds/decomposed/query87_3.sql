create table subquery610376 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1999-11-02');

create table subquery537348 as select * from subquery610376;

create table subquery190660 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery537348);

create table subquery403752 as select * from subquery190660;

create table subquery498870 as SELECT i_item_id AS item_id, SUM(sr_return_quantity) AS sr_item_qty FROM store_returns, item, date_dim WHERE sr_item_sk = i_item_sk AND d_date IN (select * from subquery403752) AND sr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery966888 as SELECT d_week_seq FROM date_dim WHERE d_date IN ('1999-08-22', '1999-02-21', '1999-11-02');

create table subquery135225 as SELECT d_date FROM date_dim WHERE d_week_seq IN (select * from subquery966888);

create table subquery642447 as SELECT i_item_id AS item_id, SUM(cr_return_quantity) AS cr_item_qty FROM catalog_returns, item, date_dim WHERE cr_item_sk = i_item_sk AND d_date IN (select * from subquery135225) AND cr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery972884 as SELECT i_item_id AS item_id, SUM(wr_return_quantity) AS wr_item_qty FROM web_returns, item, date_dim WHERE wr_item_sk = i_item_sk AND d_date IN (select * from subquery403752) AND wr_returned_date_sk = d_date_sk GROUP BY i_item_id;

create table subquery893433 as with sr_items AS (select * from subquery498870), cr_items AS (select * from subquery642447), wr_items AS (select * from subquery972884) SELECT sr_items.item_id, sr_item_qty, sr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS sr_dev, cr_item_qty, cr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS cr_dev, wr_item_qty, wr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 AS wr_dev, (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 AS average FROM sr_items, cr_items, wr_items WHERE sr_items.item_id = cr_items.item_id AND sr_items.item_id = wr_items.item_id ORDER BY sr_items.item_id, sr_item_qty;

WITH sr_items AS (select * from subquery498870), cr_items AS (select * from subquery642447), wr_items AS (select * from subquery972884) SELECT * FROM (select * from subquery893433) WHERE rownum <= 100;

