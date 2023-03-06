create table subquery901014 as SELECT i_manager_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manager_id) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1193 + 11, 1193, 1193 + 3, 1193 + 5, 1193 + 2, 1193 + 10, 1193 + 8, 1193 + 7, 1193 + 9, 1193 + 4, 1193 + 1) AND ((i_category IN ('Children', 'Electronics') AND i_class IN ('self-help') AND i_brand IN ('exportiunivamalg #9')) OR (i_category IN ('Music', 'Women', 'Men') AND i_class IN ('pants', 'accessories', 'classical') AND i_brand IN ('edu packscholar #1', 'importoamalg #1', 'amalgimporto #1', 'exportiimporto #1'))) GROUP BY i_manager_id, d_moy;

create table subquery540676 as SELECT * FROM (select * from subquery901014) AS tmp1 WHERE CASE WHEN avg_monthly_sales > 0 THEN ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales ELSE NULL END > 0.1 ORDER BY i_manager_id, avg_monthly_sales, sum_sales;

SELECT * FROM (select * from subquery540676) WHERE rownum <= 100;

