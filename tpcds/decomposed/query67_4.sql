create table subquery595245 as SELECT i_manager_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manager_id) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1195 + 11, 1195 + 7, 1195 + 5, 1195 + 1, 1195 + 8, 1195 + 10, 1195 + 2, 1195 + 3, 1195 + 4) AND ((i_category IN ('Children', 'Electronics') AND i_class IN ('self-help') AND i_brand IN ('exportiunivamalg #9', 'scholaramalgamalg #7')) OR (i_category IN ('Music') AND i_class IN ('accessories', 'fragrances', 'pants') AND i_brand IN ('amalgimporto #1', 'exportiimporto #1', 'edu packscholar #1', 'importoamalg #1'))) GROUP BY i_manager_id, d_moy;

create table subquery52763 as SELECT * FROM (select * from subquery595245) AS tmp1 WHERE CASE WHEN avg_monthly_sales > 0 THEN ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales ELSE NULL END > 0.1 ORDER BY i_manager_id, avg_monthly_sales, sum_sales;

SELECT * FROM (select * from subquery52763) WHERE rownum <= 100;

