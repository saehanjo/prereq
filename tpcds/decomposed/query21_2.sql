create table subquery741275 as SELECT i_item_id, i_item_desc, i_category, i_class, i_current_price, SUM(cs_ext_sales_price) AS itemrevenue, SUM(cs_ext_sales_price) * 100 / SUM(SUM(cs_ext_sales_price)) OVER(PARTITION BY i_class) AS revenueratio FROM catalog_sales, item, date_dim WHERE cs_item_sk = i_item_sk AND i_category IN ('Music', 'Home', 'Books') AND cs_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('1998-05-30' AS DATE) AND (CAST('1998-05-30' AS DATE) + 30) GROUP BY i_item_id, i_item_desc, i_category, i_class, i_current_price ORDER BY i_category, i_class, i_item_id, i_item_desc, revenueratio;

SELECT * FROM (select * from subquery741275) WHERE rownum <= 100;

