create table subquery93629 as SELECT i_category, i_class, i_brand, s_store_name, s_company_name, d_moy, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_category, i_brand, s_store_name, s_company_name) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_year IN (2001) AND ((i_category IN ('Children') AND i_class IN ('audio', 'school-uniforms')) OR (i_category IN ('Shoes') AND i_class IN ('pants', 'tennis'))) GROUP BY i_category, i_class, i_brand, s_store_name, s_company_name, d_moy;

create table subquery438079 as SELECT * FROM (select * from subquery93629) AS tmp1 WHERE CASE WHEN (avg_monthly_sales <> 0) THEN (ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales) ELSE NULL END > 0.1 ORDER BY sum_sales - avg_monthly_sales, s_store_name;

SELECT * FROM (select * from subquery438079) WHERE rownum <= 100;

