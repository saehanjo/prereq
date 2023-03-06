create table subquery960380 as SELECT i_item_id, i_item_desc, i_current_price FROM item, inventory, date_dim, catalog_sales WHERE i_current_price BETWEEN 39 AND 39 + 30 AND inv_item_sk = i_item_sk AND d_date_sk = inv_date_sk AND d_date BETWEEN CAST('1998-07-16' AS DATE) AND (CAST('1998-07-16' AS DATE) + 60) AND i_manufact_id IN (875, 839, 819) AND inv_quantity_on_hand BETWEEN 100 AND 500 AND cs_item_sk = i_item_sk GROUP BY i_item_id, i_item_desc, i_current_price ORDER BY i_item_id;

SELECT * FROM (select * from subquery960380) WHERE rownum <= 100;

