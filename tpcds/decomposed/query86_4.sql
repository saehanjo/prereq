create table subquery153989 as SELECT i_item_id, i_item_desc, i_current_price FROM item, inventory, date_dim, store_sales WHERE i_current_price BETWEEN 50 AND 50 + 30 AND inv_item_sk = i_item_sk AND d_date_sk = inv_date_sk AND d_date BETWEEN CAST('2000-01-22' AS DATE) AND (CAST('2000-01-22' AS DATE) + 60) AND i_manufact_id IN (123, 935) AND inv_quantity_on_hand BETWEEN 100 AND 500 AND ss_item_sk = i_item_sk GROUP BY i_item_id, i_item_desc, i_current_price ORDER BY i_item_id;

SELECT * FROM (select * from subquery153989) WHERE rownum <= 100;

