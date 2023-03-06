create table subquery755492 as SELECT 'catalog' AS channel, 'cs_warehouse_sk' AS col_name, d_year, d_qoy, i_category, cs_ext_sales_price AS ext_sales_price FROM catalog_sales, item, date_dim WHERE cs_warehouse_sk IS NULL AND cs_sold_date_sk = d_date_sk AND cs_item_sk = i_item_sk;

create table subquery467308 as SELECT 'web' AS channel, 'ws_web_page_sk' AS col_name, d_year, d_qoy, i_category, ws_ext_sales_price AS ext_sales_price FROM web_sales, item, date_dim WHERE ws_web_page_sk IS NULL AND ws_sold_date_sk = d_date_sk AND ws_item_sk = i_item_sk;

create table subquery628196 as SELECT 'store' AS channel, 'ss_hdemo_sk' AS col_name, d_year, d_qoy, i_category, ss_ext_sales_price AS ext_sales_price FROM store_sales, item, date_dim WHERE ss_hdemo_sk IS NULL AND ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk;

create table subquery264663 as SELECT channel, col_name, d_year, d_qoy, i_category, COUNT(*) AS sales_cnt, SUM(ext_sales_price) AS sales_amt FROM (select * from subquery628196 UNION ALL select * from subquery467308 UNION ALL select * from subquery755492) AS foo GROUP BY channel, col_name, d_year, d_qoy, i_category ORDER BY channel, col_name, d_year, d_qoy, i_category;

SELECT * FROM (select * from subquery264663) WHERE rownum <= 100;

