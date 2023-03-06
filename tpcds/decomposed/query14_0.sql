create table subquery97535 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1999 AND 1999 + 2;

create table subquery210174 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1999 AND 1999 + 2;

create table subquery531386 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1999 AND 1999 + 2;

create table subquery227898 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery531386 INTERSECT select * from subquery210174 INTERSECT select * from subquery97535) WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery620541 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1999 AND 1999 + 2;

create table subquery285762 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1999 AND 1999 + 2;

create table subquery511365 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1999 AND 1999 + 2;

create table subquery651799 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery511365 UNION ALL select * from subquery285762 UNION ALL select * from subquery620541) AS x;

create table subquery760501 as with cross_items AS (select * from subquery227898) SELECT ss_item_sk FROM cross_items;

create table subquery619654 as with cross_items AS (select * from subquery227898) select * from subquery760501;

create table subquery630069 as with cross_items AS (select * from subquery227898) select * from subquery619654;

create table subquery992098 as with avg_sales AS (select * from subquery651799) SELECT average_sales FROM avg_sales;

create table subquery241440 as with avg_sales AS (select * from subquery651799) select * from subquery992098;

create table subquery253620 as with avg_sales AS (select * from subquery651799) select * from subquery241440;

create table subquery405514 as with cross_items AS (select * from subquery227898), avg_sales AS (select * from subquery651799) SELECT 'web' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ws_quantity * ws_list_price) AS sales, COUNT(*) AS number_sales FROM web_sales, item, date_dim WHERE ws_item_sk IN (select * from subquery630069) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1999 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ws_quantity * ws_list_price) > (select * from subquery253620);

create table subquery101326 as with cross_items AS (select * from subquery227898), avg_sales AS (select * from subquery651799) SELECT 'catalog' AS channel, i_brand_id, i_class_id, i_category_id, SUM(cs_quantity * cs_list_price) AS sales, COUNT(*) AS number_sales FROM catalog_sales, item, date_dim WHERE cs_item_sk IN (select * from subquery630069) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1999 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(cs_quantity * cs_list_price) > (select * from subquery253620);

create table subquery758940 as with cross_items AS (select * from subquery227898), avg_sales AS (select * from subquery651799) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery630069) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1999 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery253620);

create table subquery634271 as with cross_items AS (select * from subquery227898), avg_sales AS (select * from subquery651799) SELECT channel, i_brand_id, i_class_id, i_category_id, SUM(sales), SUM(number_sales) FROM (select * from subquery758940 UNION ALL select * from subquery101326 UNION ALL select * from subquery405514) AS y GROUP BY ROLLUP(channel, i_brand_id, i_class_id, i_category_id) ORDER BY channel, i_brand_id, i_class_id, i_category_id;

WITH cross_items AS (select * from subquery227898), avg_sales AS (select * from subquery651799) SELECT * FROM (select * from subquery634271) WHERE rownum <= 100;

