create table subquery551918 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery875106 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery312945 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery697823 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery312945 INTERSECT select * from subquery875106 INTERSECT select * from subquery551918) WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery727681 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery700620 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery105724 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery236720 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery105724 UNION ALL select * from subquery700620 UNION ALL select * from subquery727681) AS x;

create table subquery635251 as with cross_items AS (select * from subquery697823) SELECT ss_item_sk FROM cross_items;

create table subquery229813 as with cross_items AS (select * from subquery697823) select * from subquery635251;

create table subquery991925 as with cross_items AS (select * from subquery697823) select * from subquery229813;

create table subquery73027 as with avg_sales AS (select * from subquery236720) SELECT average_sales FROM avg_sales;

create table subquery856287 as with avg_sales AS (select * from subquery236720) select * from subquery73027;

create table subquery515486 as with avg_sales AS (select * from subquery236720) select * from subquery856287;

create table subquery395136 as with cross_items AS (select * from subquery697823), avg_sales AS (select * from subquery236720) SELECT 'web' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ws_quantity * ws_list_price) AS sales, COUNT(*) AS number_sales FROM web_sales, item, date_dim WHERE ws_item_sk IN (select * from subquery991925) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ws_quantity * ws_list_price) > (select * from subquery515486);

create table subquery980890 as with cross_items AS (select * from subquery697823), avg_sales AS (select * from subquery236720) SELECT 'catalog' AS channel, i_brand_id, i_class_id, i_category_id, SUM(cs_quantity * cs_list_price) AS sales, COUNT(*) AS number_sales FROM catalog_sales, item, date_dim WHERE cs_item_sk IN (select * from subquery991925) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(cs_quantity * cs_list_price) > (select * from subquery515486);

create table subquery878526 as with cross_items AS (select * from subquery697823), avg_sales AS (select * from subquery236720) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery991925) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery515486);

create table subquery375564 as with cross_items AS (select * from subquery697823), avg_sales AS (select * from subquery236720) SELECT channel, i_brand_id, i_class_id, i_category_id, SUM(sales), SUM(number_sales) FROM (select * from subquery878526 UNION ALL select * from subquery980890 UNION ALL select * from subquery395136) AS y GROUP BY ROLLUP(channel, i_brand_id, i_class_id, i_category_id) ORDER BY channel, i_brand_id, i_class_id, i_category_id;

WITH cross_items AS (select * from subquery697823), avg_sales AS (select * from subquery236720) SELECT * FROM (select * from subquery375564) WHERE rownum <= 100;

