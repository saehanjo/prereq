create table subquery238196 as SELECT i_item_id, i_item_desc, i_current_price FROM item, inventory, date_dim, store_sales WHERE i_current_price BETWEEN 25 AND 25 + 30 AND inv_item_sk = i_item_sk AND d_date_sk = inv_date_sk AND d_date BETWEEN CAST('1999-07-06' AS DATE) AND (CAST('1999-07-06' AS DATE) + 60) AND i_manufact_id IN (639, 953) AND inv_quantity_on_hand BETWEEN 100 AND 500 AND ss_item_sk = i_item_sk GROUP BY i_item_id, i_item_desc, i_current_price ORDER BY i_item_id;

SELECT * FROM (select * from subquery238196) WHERE rownum <= 100;

