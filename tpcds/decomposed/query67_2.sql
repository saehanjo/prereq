create table subquery846889 as SELECT i_manager_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manager_id) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1210 + 7, 1210 + 1, 1210 + 4, 1210 + 3, 1210 + 2, 1210 + 8, 1210 + 5, 1210 + 9, 1210 + 6, 1210 + 11, 1210, 1210 + 10) AND ((i_category IN ('Children', 'Electronics') AND i_class IN ('personal', 'reference', 'portable') AND i_brand IN ('exportiunivamalg #9', 'scholaramalgamalg #9')) OR (i_category IN ('Women') AND i_class IN ('accessories', 'classical', 'fragrances', 'pants') AND i_brand IN ('edu packscholar #1', 'exportiimporto #1', 'importoamalg #1', 'amalgimporto #1'))) GROUP BY i_manager_id, d_moy;

create table subquery461123 as SELECT * FROM (select * from subquery846889) AS tmp1 WHERE CASE WHEN avg_monthly_sales > 0 THEN ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales ELSE NULL END > 0.1 ORDER BY i_manager_id, avg_monthly_sales, sum_sales;

SELECT * FROM (select * from subquery461123) WHERE rownum <= 100;

