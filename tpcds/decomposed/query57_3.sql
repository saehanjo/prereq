create table subquery887088 as SELECT i_manufact_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manufact_id) AS avg_quarterly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1203 + 4, 1203 + 3) AND ((i_category IN ('Books') AND i_class IN ('personal') AND i_brand IN ('scholaramalgamalg #14', 'scholaramalgamalg #9')) OR (i_category IN ('Men') AND i_class IN ('classical', 'fragrances', 'accessories', 'pants') AND i_brand IN ('importoamalg #1', 'edu packscholar #1', 'amalgimporto #1', 'exportiimporto #1'))) GROUP BY i_manufact_id, d_qoy;

create table subquery279259 as SELECT * FROM (select * from subquery887088) AS tmp1 WHERE CASE WHEN avg_quarterly_sales > 0 THEN ABS(sum_sales - avg_quarterly_sales) / avg_quarterly_sales ELSE NULL END > 0.1 ORDER BY avg_quarterly_sales, sum_sales, i_manufact_id;

SELECT * FROM (select * from subquery279259) WHERE rownum <= 100;

