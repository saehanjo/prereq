create table subquery501296 as SELECT i_manufact_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manufact_id) AS avg_quarterly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1214 + 8, 1214 + 2, 1214 + 1, 1214 + 7) AND ((i_category IN ('Children', 'Electronics', 'Books') AND i_class IN ('personal', 'portable') AND i_brand IN ('scholaramalgamalg #14', 'scholaramalgamalg #9', 'exportiunivamalg #9', 'scholaramalgamalg #7')) OR (i_category IN ('Women') AND i_class IN ('classical', 'fragrances', 'accessories', 'pants') AND i_brand IN ('edu packscholar #1', 'amalgimporto #1', 'exportiimporto #1'))) GROUP BY i_manufact_id, d_qoy;

create table subquery54487 as SELECT * FROM (select * from subquery501296) AS tmp1 WHERE CASE WHEN avg_quarterly_sales > 0 THEN ABS(sum_sales - avg_quarterly_sales) / avg_quarterly_sales ELSE NULL END > 0.1 ORDER BY avg_quarterly_sales, sum_sales, i_manufact_id;

SELECT * FROM (select * from subquery54487) WHERE rownum <= 100;

