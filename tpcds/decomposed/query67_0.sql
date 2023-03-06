create table subquery788633 as SELECT i_manager_id, SUM(ss_sales_price) AS sum_sales, AVG(SUM(ss_sales_price)) OVER(PARTITION BY i_manager_id) AS avg_monthly_sales FROM item, store_sales, date_dim, store WHERE ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND ss_store_sk = s_store_sk AND d_month_seq IN (1222 + 2, 1222 + 3, 1222 + 8) AND ((i_category IN ('Electronics') AND i_class IN ('reference') AND i_brand IN ('scholaramalgamalg #7', 'scholaramalgamalg #9', 'scholaramalgamalg #14')) OR (i_category IN ('Music', 'Men') AND i_class IN ('pants', 'accessories', 'classical', 'fragrances') AND i_brand IN ('exportiimporto #1'))) GROUP BY i_manager_id, d_moy;

create table subquery283208 as SELECT * FROM (select * from subquery788633) AS tmp1 WHERE CASE WHEN avg_monthly_sales > 0 THEN ABS(sum_sales - avg_monthly_sales) / avg_monthly_sales ELSE NULL END > 0.1 ORDER BY i_manager_id, avg_monthly_sales, sum_sales;

SELECT * FROM (select * from subquery283208) WHERE rownum <= 100;

