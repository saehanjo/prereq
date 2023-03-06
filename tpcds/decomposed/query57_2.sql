create table subquery797040 as SELECT i_manufact_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manufact_id) AS avg_quarterly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1192 + 7, 1192 + 3, 1192 + 10, 1192 + 8, 1192 + 1, 1192 + 5) AND ((i_category IN ('Children', 'Books', 'Electronics') AND i_class IN ('portable', 'reference') AND i_brand IN ('scholaramalgamalg #9', 'scholaramalgamalg #14')) OR (i_category IN ('Women', 'Music', 'Men') AND i_class IN ('fragrances', 'pants') AND i_brand IN ('edu packscholar #1'))) GROUP BY i_manufact_id, d_qoy;

create table subquery131196 as SELECT * FROM (select * from subquery797040) AS tmp1 WHERE CASE WHEN avg_quarterly_sales > 0 THEN ABS(sum_sales - avg_quarterly_sales) / avg_quarterly_sales ELSE NULL END > 0.1 ORDER BY avg_quarterly_sales, sum_sales, i_manufact_id;

SELECT * FROM (select * from subquery131196) WHERE rownum <= 100;

