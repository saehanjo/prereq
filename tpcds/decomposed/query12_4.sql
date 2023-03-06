create table subquery669145 as SELECT i_item_id, i_item_desc, i_category, i_class, i_current_price, SUM(ws_ext_sales_price) AS itemrevenue, SUM(ws_ext_sales_price) * 100 / SUM(SUM(ws_ext_sales_price)) OVER(PARTITION BY i_class) AS revenueratio FROM web_sales, item, date_dim WHERE ws_item_sk = i_item_sk AND i_category IN ('Men', 'Shoes') AND ws_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('2002-01-10' AS DATE) AND (CAST('2002-01-10' AS DATE) + 30) GROUP BY i_item_id, i_item_desc, i_category, i_class, i_current_price ORDER BY i_category, i_class, i_item_id, i_item_desc, revenueratio;

SELECT * FROM (select * from subquery669145) WHERE rownum <= 100;

