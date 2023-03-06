create table subquery912766 as SELECT i_item_id, i_item_desc, i_current_price FROM item, inventory, date_dim, catalog_sales WHERE i_current_price BETWEEN 29 AND 29 + 30 AND inv_item_sk = i_item_sk AND d_date_sk = inv_date_sk AND d_date BETWEEN CAST('2002-03-29' AS DATE) AND (CAST('2002-03-29' AS DATE) + 60) AND i_manufact_id IN (705, 944, 777, 742) AND inv_quantity_on_hand BETWEEN 100 AND 500 AND cs_item_sk = i_item_sk GROUP BY i_item_id, i_item_desc, i_current_price ORDER BY i_item_id;

SELECT * FROM (select * from subquery912766) WHERE rownum <= 100;

