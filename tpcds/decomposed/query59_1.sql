create table subquery145438 as SELECT i_brand_id AS brand_id, i_brand AS brand, SUM(ss_ext_sales_price) AS ext_price FROM date_dim, store_sales, item WHERE d_date_sk = ss_sold_date_sk AND ss_item_sk = i_item_sk AND i_manager_id = 88 AND d_moy = 12 AND d_year = 2001 GROUP BY i_brand, i_brand_id ORDER BY ext_price DESC, i_brand_id;

SELECT * FROM (select * from subquery145438) WHERE rownum <= 100;

