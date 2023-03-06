create table subquery23910 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery289399 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery130514 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery186295 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery130514 INTERSECT select * from subquery289399 INTERSECT select * from subquery23910) AS x WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery544414 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery754084 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery350144 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery536273 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery350144 UNION ALL select * from subquery754084 UNION ALL select * from subquery544414) AS x;

create table subquery773921 as with cross_items AS (select * from subquery186295) SELECT ss_item_sk FROM cross_items;

create table subquery142686 as with cross_items AS (select * from subquery186295) select * from subquery773921;

create table subquery214729 as SELECT d_week_seq FROM date_dim WHERE d_year = 1998 AND d_moy = 12 AND d_dom = 4;

create table subquery220427 as SELECT d_week_seq FROM date_dim WHERE d_year = 1998 + 1 AND d_moy = 12 AND d_dom = 4;

create table subquery937818 as with avg_sales AS (select * from subquery536273) SELECT average_sales FROM avg_sales;

create table subquery536293 as with avg_sales AS (select * from subquery536273) select * from subquery937818;

create table subquery926255 as with cross_items AS (select * from subquery186295), avg_sales AS (select * from subquery536273) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery142686) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery214729) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery536293);

create table subquery147246 as with cross_items AS (select * from subquery186295), avg_sales AS (select * from subquery536273) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery142686) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery220427) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery536293);

create table subquery491687 as with cross_items AS (select * from subquery186295), avg_sales AS (select * from subquery536273) SELECT this_year.channel AS ty_channel, this_year.i_brand_id AS ty_brand, this_year.i_class_id AS ty_class, this_year.i_category_id AS ty_category, this_year.sales AS ty_sales, this_year.number_sales AS ty_number_sales, last_year.channel AS ly_channel, last_year.i_brand_id AS ly_brand, last_year.i_class_id AS ly_class, last_year.i_category_id AS ly_category, last_year.sales AS ly_sales, last_year.number_sales AS ly_number_sales FROM (select * from subquery147246) AS this_year, (select * from subquery926255) AS last_year WHERE this_year.i_brand_id = last_year.i_brand_id AND this_year.i_class_id = last_year.i_class_id AND this_year.i_category_id = last_year.i_category_id ORDER BY this_year.channel, this_year.i_brand_id, this_year.i_class_id, this_year.i_category_id;

WITH cross_items AS (select * from subquery186295), avg_sales AS (select * from subquery536273) SELECT * FROM (select * from subquery491687) WHERE rownum <= 100;

