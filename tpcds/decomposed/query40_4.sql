create table subquery66448 as SELECT i_item_id, i_item_desc, i_current_price FROM item, inventory, date_dim, catalog_sales WHERE i_current_price BETWEEN 68 AND 68 + 30 AND inv_item_sk = i_item_sk AND d_date_sk = inv_date_sk AND d_date BETWEEN CAST('1999-07-14' AS DATE) AND (CAST('1999-07-14' AS DATE) + 60) AND i_manufact_id IN (682, 801, 904, 938) AND inv_quantity_on_hand BETWEEN 100 AND 500 AND cs_item_sk = i_item_sk GROUP BY i_item_id, i_item_desc, i_current_price ORDER BY i_item_id;

SELECT * FROM (select * from subquery66448) WHERE rownum <= 100;

