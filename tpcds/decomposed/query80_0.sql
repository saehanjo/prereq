create table subquery290480 as SELECT 'catalog' AS channel, 'cs_bill_customer_sk' AS col_name, d_year, d_qoy, i_category, cs_ext_sales_price AS ext_sales_price FROM catalog_sales, item, date_dim WHERE cs_bill_customer_sk IS NULL AND cs_sold_date_sk = d_date_sk AND cs_item_sk = i_item_sk;

create table subquery988840 as SELECT 'web' AS channel, 'ws_promo_sk' AS col_name, d_year, d_qoy, i_category, ws_ext_sales_price AS ext_sales_price FROM web_sales, item, date_dim WHERE ws_promo_sk IS NULL AND ws_sold_date_sk = d_date_sk AND ws_item_sk = i_item_sk;

create table subquery620913 as SELECT 'store' AS channel, 'ss_customer_sk' AS col_name, d_year, d_qoy, i_category, ss_ext_sales_price AS ext_sales_price FROM store_sales, item, date_dim WHERE ss_customer_sk IS NULL AND ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk;

create table subquery604539 as SELECT channel, col_name, d_year, d_qoy, i_category, COUNT(*) AS sales_cnt, SUM(ext_sales_price) AS sales_amt FROM (select * from subquery620913 UNION ALL select * from subquery988840 UNION ALL select * from subquery290480) AS foo GROUP BY channel, col_name, d_year, d_qoy, i_category ORDER BY channel, col_name, d_year, d_qoy, i_category;

SELECT * FROM (select * from subquery604539) WHERE rownum <= 100;

