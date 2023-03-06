create table subquery83439 as SELECT i_manager_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manager_id) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1178 + 7, 1178, 1178 + 9, 1178 + 5) AND ((i_category IN ('Books', 'Electronics', 'Children') AND i_class IN ('portable', 'self-help', 'personal', 'reference') AND i_brand IN ('scholaramalgamalg #14')) OR (i_category IN ('Music') AND i_class IN ('classical', 'pants', 'accessories') AND i_brand IN ('edu packscholar #1', 'amalgimporto #1', 'exportiimporto #1', 'importoamalg #1'))) GROUP BY i_manager_id, d_moy;

create table subquery481805 as SELECT * FROM (select * from subquery83439) AS tmp1 WHERE CASE WHEN avg_monthly_sales > 0 THEN ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales ELSE NULL END > 0.1 ORDER BY i_manager_id, avg_monthly_sales, sum_sales;

SELECT * FROM (select * from subquery481805) WHERE rownum <= 100;

