create table subquery826950 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery984968 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery369907 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery191250 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery369907 INTERSECT select * from subquery984968 INTERSECT select * from subquery826950) WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery551383 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery712755 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery817541 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery386740 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery817541 UNION ALL select * from subquery712755 UNION ALL select * from subquery551383) AS x;

create table subquery751112 as with cross_items AS (select * from subquery191250) SELECT ss_item_sk FROM cross_items;

create table subquery61180 as with cross_items AS (select * from subquery191250) select * from subquery751112;

create table subquery856982 as with cross_items AS (select * from subquery191250) select * from subquery61180;

create table subquery761427 as with avg_sales AS (select * from subquery386740) SELECT average_sales FROM avg_sales;

create table subquery147365 as with avg_sales AS (select * from subquery386740) select * from subquery761427;

create table subquery818715 as with avg_sales AS (select * from subquery386740) select * from subquery147365;

create table subquery390120 as with cross_items AS (select * from subquery191250), avg_sales AS (select * from subquery386740) SELECT 'web' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ws_quantity * ws_list_price) AS sales, COUNT(*) AS number_sales FROM web_sales, item, date_dim WHERE ws_item_sk IN (select * from subquery856982) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ws_quantity * ws_list_price) > (select * from subquery818715);

create table subquery720720 as with cross_items AS (select * from subquery191250), avg_sales AS (select * from subquery386740) SELECT 'catalog' AS channel, i_brand_id, i_class_id, i_category_id, SUM(cs_quantity * cs_list_price) AS sales, COUNT(*) AS number_sales FROM catalog_sales, item, date_dim WHERE cs_item_sk IN (select * from subquery856982) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(cs_quantity * cs_list_price) > (select * from subquery818715);

create table subquery665450 as with cross_items AS (select * from subquery191250), avg_sales AS (select * from subquery386740) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery856982) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery818715);

create table subquery121588 as with cross_items AS (select * from subquery191250), avg_sales AS (select * from subquery386740) SELECT channel, i_brand_id, i_class_id, i_category_id, SUM(sales), SUM(number_sales) FROM (select * from subquery665450 UNION ALL select * from subquery720720 UNION ALL select * from subquery390120) AS y GROUP BY ROLLUP(channel, i_brand_id, i_class_id, i_category_id) ORDER BY channel, i_brand_id, i_class_id, i_category_id;

WITH cross_items AS (select * from subquery191250), avg_sales AS (select * from subquery386740) SELECT * FROM (select * from subquery121588) WHERE rownum <= 100;

