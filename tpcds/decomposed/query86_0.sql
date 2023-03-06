create table subquery223903 as SELECT i_item_id, i_item_desc, i_current_price FROM item, inventory, date_dim, store_sales WHERE i_current_price BETWEEN 58 AND 58 + 30 AND inv_item_sk = i_item_sk AND d_date_sk = inv_date_sk AND d_date BETWEEN CAST('2001-01-13' AS DATE) AND (CAST('2001-01-13' AS DATE) + 60) AND i_manufact_id IN (485) AND inv_quantity_on_hand BETWEEN 100 AND 500 AND ss_item_sk = i_item_sk GROUP BY i_item_id, i_item_desc, i_current_price ORDER BY i_item_id;

SELECT * FROM (select * from subquery223903) WHERE rownum <= 100;

