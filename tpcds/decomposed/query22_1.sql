create table subquery161873 as SELECT w_warehouse_name, i_item_id, SUM(CASE WHEN (CAST(d_date AS DATE) < CAST('2002-05-15' AS DATE)) THEN inv_quantity_on_hand ELSE 0 END) AS inv_before, SUM(CASE WHEN (CAST(d_date AS DATE) >= CAST('2002-05-15' AS DATE)) THEN inv_quantity_on_hand ELSE 0 END) AS inv_after FROM inventory, warehouse, item, date_dim WHERE i_current_price BETWEEN 0.99 AND 1.49 AND i_item_sk = inv_item_sk AND inv_warehouse_sk = w_warehouse_sk AND inv_date_sk = d_date_sk AND d_date BETWEEN (CAST('2002-05-15' AS DATE) - 30) AND (CAST('2002-05-15' AS DATE) + 30) GROUP BY w_warehouse_name, i_item_id;

create table subquery835096 as SELECT * FROM (select * from subquery161873) AS x WHERE (CASE WHEN inv_before > 0 THEN inv_after / inv_before ELSE NULL END) BETWEEN 2.0 / 3.0 AND 3.0 / 2.0 ORDER BY w_warehouse_name, i_item_id;

SELECT * FROM (select * from subquery835096) WHERE rownum <= 100;

