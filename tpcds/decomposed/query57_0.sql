create table subquery826475 as SELECT i_manufact_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manufact_id) AS avg_quarterly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1186 + 3, 1186 + 8, 1186 + 4, 1186 + 6, 1186 + 7, 1186 + 2) AND ((i_category IN ('Children') AND i_class IN ('personal', 'self-help', 'portable') AND i_brand IN ('scholaramalgamalg #14', 'scholaramalgamalg #9', 'exportiunivamalg #9')) OR (i_category IN ('Men', 'Women', 'Music') AND i_class IN ('accessories', 'pants', 'fragrances') AND i_brand IN ('amalgimporto #1', 'edu packscholar #1'))) GROUP BY i_manufact_id, d_qoy;

create table subquery767455 as SELECT * FROM (select * from subquery826475) AS tmp1 WHERE CASE WHEN avg_quarterly_sales > 0 THEN ABS(sum_sales - avg_quarterly_sales) / avg_quarterly_sales ELSE NULL END > 0.1 ORDER BY avg_quarterly_sales, sum_sales, i_manufact_id;

SELECT * FROM (select * from subquery767455) WHERE rownum <= 100;

