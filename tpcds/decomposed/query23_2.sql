create table subquery609702 as SELECT i_product_name, i_brand, i_class, i_category, AVG(inv_quantity_on_hand) AS qoh FROM inventory, date_dim, item WHERE inv_date_sk = d_date_sk AND inv_item_sk = i_item_sk AND d_month_seq BETWEEN 1204 AND 1204 + 11 GROUP BY ROLLUP(i_product_name, i_brand, i_class, i_category) ORDER BY qoh, i_product_name, i_brand, i_class, i_category;

SELECT * FROM (select * from subquery609702) WHERE rownum <= 100;

