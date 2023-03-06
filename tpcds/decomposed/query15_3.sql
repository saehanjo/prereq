create table subquery369941 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery185844 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery452631 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1998 AND 1998 + 2;

create table subquery496420 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery452631 INTERSECT select * from subquery185844 INTERSECT select * from subquery369941) AS x WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery362929 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery10286 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery103909 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1998 AND 1998 + 2;

create table subquery224534 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery103909 UNION ALL select * from subquery10286 UNION ALL select * from subquery362929) AS x;

create table subquery410999 as with cross_items AS (select * from subquery496420) SELECT ss_item_sk FROM cross_items;

create table subquery722370 as with cross_items AS (select * from subquery496420) select * from subquery410999;

create table subquery12610 as SELECT d_week_seq FROM date_dim WHERE d_year = 1998 AND d_moy = 12 AND d_dom = 8;

create table subquery692087 as SELECT d_week_seq FROM date_dim WHERE d_year = 1998 + 1 AND d_moy = 12 AND d_dom = 8;

create table subquery555884 as with avg_sales AS (select * from subquery224534) SELECT average_sales FROM avg_sales;

create table subquery428553 as with avg_sales AS (select * from subquery224534) select * from subquery555884;

create table subquery60977 as with cross_items AS (select * from subquery496420), avg_sales AS (select * from subquery224534) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery722370) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery12610) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery428553);

create table subquery631902 as with cross_items AS (select * from subquery496420), avg_sales AS (select * from subquery224534) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery722370) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery692087) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery428553);

create table subquery887235 as with cross_items AS (select * from subquery496420), avg_sales AS (select * from subquery224534) SELECT this_year.channel AS ty_channel, this_year.i_brand_id AS ty_brand, this_year.i_class_id AS ty_class, this_year.i_category_id AS ty_category, this_year.sales AS ty_sales, this_year.number_sales AS ty_number_sales, last_year.channel AS ly_channel, last_year.i_brand_id AS ly_brand, last_year.i_class_id AS ly_class, last_year.i_category_id AS ly_category, last_year.sales AS ly_sales, last_year.number_sales AS ly_number_sales FROM (select * from subquery631902) AS this_year, (select * from subquery60977) AS last_year WHERE this_year.i_brand_id = last_year.i_brand_id AND this_year.i_class_id = last_year.i_class_id AND this_year.i_category_id = last_year.i_category_id ORDER BY this_year.channel, this_year.i_brand_id, this_year.i_class_id, this_year.i_category_id;

WITH cross_items AS (select * from subquery496420), avg_sales AS (select * from subquery224534) SELECT * FROM (select * from subquery887235) WHERE rownum <= 100;

