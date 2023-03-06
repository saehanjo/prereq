create table subquery216478 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery780528 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery2241 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery903001 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery2241 INTERSECT select * from subquery780528 INTERSECT select * from subquery216478) AS x WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery682161 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery793464 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery847548 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery293907 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery847548 UNION ALL select * from subquery793464 UNION ALL select * from subquery682161) AS x;

create table subquery409526 as with cross_items AS (select * from subquery903001) SELECT ss_item_sk FROM cross_items;

create table subquery483383 as with cross_items AS (select * from subquery903001) select * from subquery409526;

create table subquery107464 as SELECT d_week_seq FROM date_dim WHERE d_year = 1998 AND d_moy = 12 AND d_dom = 20;

create table subquery936303 as SELECT d_week_seq FROM date_dim WHERE d_year = 1998 + 1 AND d_moy = 12 AND d_dom = 20;

create table subquery894344 as with avg_sales AS (select * from subquery293907) SELECT average_sales FROM avg_sales;

create table subquery23873 as with avg_sales AS (select * from subquery293907) select * from subquery894344;

create table subquery426592 as with cross_items AS (select * from subquery903001), avg_sales AS (select * from subquery293907) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery483383) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery107464) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery23873);

create table subquery509557 as with cross_items AS (select * from subquery903001), avg_sales AS (select * from subquery293907) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery483383) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery936303) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery23873);

create table subquery964875 as with cross_items AS (select * from subquery903001), avg_sales AS (select * from subquery293907) SELECT this_year.channel AS ty_channel, this_year.i_brand_id AS ty_brand, this_year.i_class_id AS ty_class, this_year.i_category_id AS ty_category, this_year.sales AS ty_sales, this_year.number_sales AS ty_number_sales, last_year.channel AS ly_channel, last_year.i_brand_id AS ly_brand, last_year.i_class_id AS ly_class, last_year.i_category_id AS ly_category, last_year.sales AS ly_sales, last_year.number_sales AS ly_number_sales FROM (select * from subquery509557) AS this_year, (select * from subquery426592) AS last_year WHERE this_year.i_brand_id = last_year.i_brand_id AND this_year.i_class_id = last_year.i_class_id AND this_year.i_category_id = last_year.i_category_id ORDER BY this_year.channel, this_year.i_brand_id, this_year.i_class_id, this_year.i_category_id;

WITH cross_items AS (select * from subquery903001), avg_sales AS (select * from subquery293907) SELECT * FROM (select * from subquery964875) WHERE rownum <= 100;

