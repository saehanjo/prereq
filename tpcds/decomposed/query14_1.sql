create table subquery588538 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery701368 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery264526 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery587045 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery264526 INTERSECT select * from subquery701368 INTERSECT select * from subquery588538) WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery279364 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery419102 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery357535 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery577212 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery357535 UNION ALL select * from subquery419102 UNION ALL select * from subquery279364) AS x;

create table subquery369513 as with cross_items AS (select * from subquery587045) SELECT ss_item_sk FROM cross_items;

create table subquery880962 as with cross_items AS (select * from subquery587045) select * from subquery369513;

create table subquery737862 as with cross_items AS (select * from subquery587045) select * from subquery880962;

create table subquery340782 as with avg_sales AS (select * from subquery577212) SELECT average_sales FROM avg_sales;

create table subquery74733 as with avg_sales AS (select * from subquery577212) select * from subquery340782;

create table subquery359343 as with avg_sales AS (select * from subquery577212) select * from subquery74733;

create table subquery451623 as with cross_items AS (select * from subquery587045), avg_sales AS (select * from subquery577212) SELECT 'web' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ws_quantity * ws_list_price) AS sales, COUNT(*) AS number_sales FROM web_sales, item, date_dim WHERE ws_item_sk IN (select * from subquery737862) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ws_quantity * ws_list_price) > (select * from subquery359343);

create table subquery923448 as with cross_items AS (select * from subquery587045), avg_sales AS (select * from subquery577212) SELECT 'catalog' AS channel, i_brand_id, i_class_id, i_category_id, SUM(cs_quantity * cs_list_price) AS sales, COUNT(*) AS number_sales FROM catalog_sales, item, date_dim WHERE cs_item_sk IN (select * from subquery737862) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(cs_quantity * cs_list_price) > (select * from subquery359343);

create table subquery667248 as with cross_items AS (select * from subquery587045), avg_sales AS (select * from subquery577212) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery737862) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 1998 + 2 AND d_moy = 11 GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery359343);

create table subquery912320 as with cross_items AS (select * from subquery587045), avg_sales AS (select * from subquery577212) SELECT channel, i_brand_id, i_class_id, i_category_id, SUM(sales), SUM(number_sales) FROM (select * from subquery667248 UNION ALL select * from subquery923448 UNION ALL select * from subquery451623) AS y GROUP BY ROLLUP(channel, i_brand_id, i_class_id, i_category_id) ORDER BY channel, i_brand_id, i_class_id, i_category_id;

WITH cross_items AS (select * from subquery587045), avg_sales AS (select * from subquery577212) SELECT * FROM (select * from subquery912320) WHERE rownum <= 100;

