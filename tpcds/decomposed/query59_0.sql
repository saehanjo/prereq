create table subquery77985 as SELECT i_brand_id AS brand_id, i_brand AS brand, SUM(ss_ext_sales_price) AS ext_price FROM date_dim, store_sales, item WHERE d_date_sk = ss_sold_date_sk AND ss_item_sk = i_item_sk AND i_manager_id = 52 AND d_moy = 11 AND d_year = 2000 GROUP BY i_brand, i_brand_id ORDER BY ext_price DESC, i_brand_id;

SELECT * FROM (select * from subquery77985) WHERE rownum <= 100;

