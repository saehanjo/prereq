create table subquery149722 as SELECT i_category, i_class, i_brand, s_store_name, s_company_name, d_moy, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_category, i_brand, s_store_name, s_company_name) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_year IN (2002) AND ((i_category IN ('Children', 'Shoes', 'Women') AND i_class IN ('kids', 'swimwear', 'infants')) OR (i_category IN ('Men', 'Sports') AND i_class IN ('shirts'))) GROUP BY i_category, i_class, i_brand, s_store_name, s_company_name, d_moy;

create table subquery45259 as SELECT * FROM (select * from subquery149722) AS tmp1 WHERE CASE WHEN (avg_monthly_sales <> 0) THEN (ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales) ELSE NULL END > 0.1 ORDER BY sum_sales - avg_monthly_sales, s_store_name;

SELECT * FROM (select * from subquery45259) WHERE rownum <= 100;

