create table subquery655709 as SELECT i_manufact_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manufact_id) AS avg_quarterly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1181 + 1, 1181 + 8) AND ((i_category IN ('Electronics', 'Children') AND i_class IN ('reference') AND i_brand IN ('scholaramalgamalg #14')) OR (i_category IN ('Women', 'Men') AND i_class IN ('accessories', 'pants', 'classical', 'fragrances') AND i_brand IN ('exportiimporto #1', 'amalgimporto #1'))) GROUP BY i_manufact_id, d_qoy;

create table subquery724855 as SELECT * FROM (select * from subquery655709) AS tmp1 WHERE CASE WHEN avg_quarterly_sales > 0 THEN ABS(sum_sales - avg_quarterly_sales) / avg_quarterly_sales ELSE NULL END > 0.1 ORDER BY avg_quarterly_sales, sum_sales, i_manufact_id;

SELECT * FROM (select * from subquery724855) WHERE rownum <= 100;

