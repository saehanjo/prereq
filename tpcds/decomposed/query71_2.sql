create table subquery34167 as SELECT i_category, i_class, i_brand, i_product_name, d_year, d_qoy, d_moy, s_store_id, SUM(COALESCE(ss_sales_price * ss_quantity, 0)) AS sumsales FROM store_sales, date_dim, store, item WHERE ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk AND ss_store_sk = s_store_sk AND d_month_seq BETWEEN 1208 AND 1208 + 11 GROUP BY ROLLUP(i_category, i_class, i_brand, i_product_name, d_year, d_qoy, d_moy, s_store_id);

create table subquery524656 as SELECT i_category, i_class, i_brand, i_product_name, d_year, d_qoy, d_moy, s_store_id, sumsales, RANK() OVER(PARTITION BY i_category ORDER BY sumsales DESC) AS rk FROM (select * from subquery34167) AS dw1;

create table subquery328017 as SELECT * FROM (select * from subquery524656) AS dw2 WHERE rk <= 100 ORDER BY i_category, i_class, i_brand, i_product_name, d_year, d_qoy, d_moy, s_store_id, sumsales, rk;

SELECT * FROM (select * from subquery328017) WHERE rownum <= 100;

