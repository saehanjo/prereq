create table subquery527503 as SELECT 'catalog' AS channel, 'cs_ship_cdemo_sk' AS col_name, d_year, d_qoy, i_category, cs_ext_sales_price AS ext_sales_price FROM catalog_sales, item, date_dim WHERE cs_ship_cdemo_sk IS NULL AND cs_sold_date_sk = d_date_sk AND cs_item_sk = i_item_sk;

create table subquery11184 as SELECT 'web' AS channel, 'ws_bill_hdemo_sk' AS col_name, d_year, d_qoy, i_category, ws_ext_sales_price AS ext_sales_price FROM web_sales, item, date_dim WHERE ws_bill_hdemo_sk IS NULL AND ws_sold_date_sk = d_date_sk AND ws_item_sk = i_item_sk;

create table subquery615513 as SELECT 'store' AS channel, 'ss_cdemo_sk' AS col_name, d_year, d_qoy, i_category, ss_ext_sales_price AS ext_sales_price FROM store_sales, item, date_dim WHERE ss_cdemo_sk IS NULL AND ss_sold_date_sk = d_date_sk AND ss_item_sk = i_item_sk;

create table subquery12383 as SELECT channel, col_name, d_year, d_qoy, i_category, COUNT(*) AS sales_cnt, SUM(ext_sales_price) AS sales_amt FROM (select * from subquery615513 UNION ALL select * from subquery11184 UNION ALL select * from subquery527503) AS foo GROUP BY channel, col_name, d_year, d_qoy, i_category ORDER BY channel, col_name, d_year, d_qoy, i_category;

SELECT * FROM (select * from subquery12383) WHERE rownum <= 100;

