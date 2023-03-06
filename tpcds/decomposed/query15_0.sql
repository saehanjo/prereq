create table subquery916150 as SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id FROM web_sales, item AS iws, date_dim AS d3 WHERE ws_item_sk = iws.i_item_sk AND ws_sold_date_sk = d3.d_date_sk AND d3.d_year BETWEEN 1999 AND 1999 + 2;

create table subquery126902 as SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id FROM catalog_sales, item AS ics, date_dim AS d2 WHERE cs_item_sk = ics.i_item_sk AND cs_sold_date_sk = d2.d_date_sk AND d2.d_year BETWEEN 1999 AND 1999 + 2;

create table subquery431538 as SELECT iss.i_brand_id AS brand_id, iss.i_class_id AS class_id, iss.i_category_id AS category_id FROM store_sales, item AS iss, date_dim AS d1 WHERE ss_item_sk = iss.i_item_sk AND ss_sold_date_sk = d1.d_date_sk AND d1.d_year BETWEEN 1999 AND 1999 + 2;

create table subquery335661 as SELECT i_item_sk AS ss_item_sk FROM item, (select * from subquery431538 INTERSECT select * from subquery126902 INTERSECT select * from subquery916150) AS x WHERE i_brand_id = brand_id AND i_class_id = class_id AND i_category_id = category_id;

create table subquery439430 as SELECT ws_quantity AS quantity, ws_list_price AS list_price FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_year BETWEEN 1999 AND 1999 + 2;

create table subquery662226 as SELECT cs_quantity AS quantity, cs_list_price AS list_price FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_year BETWEEN 1999 AND 1999 + 2;

create table subquery306869 as SELECT ss_quantity AS quantity, ss_list_price AS list_price FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_year BETWEEN 1999 AND 1999 + 2;

create table subquery746034 as SELECT AVG(quantity * list_price) AS average_sales FROM (select * from subquery306869 UNION ALL select * from subquery662226 UNION ALL select * from subquery439430) AS x;

create table subquery998917 as with cross_items AS (select * from subquery335661) SELECT ss_item_sk FROM cross_items;

create table subquery810679 as with cross_items AS (select * from subquery335661) select * from subquery998917;

create table subquery209527 as SELECT d_week_seq FROM date_dim WHERE d_year = 1999 AND d_moy = 12 AND d_dom = 3;

create table subquery428029 as SELECT d_week_seq FROM date_dim WHERE d_year = 1999 + 1 AND d_moy = 12 AND d_dom = 3;

create table subquery920146 as with avg_sales AS (select * from subquery746034) SELECT average_sales FROM avg_sales;

create table subquery858767 as with avg_sales AS (select * from subquery746034) select * from subquery920146;

create table subquery511963 as with cross_items AS (select * from subquery335661), avg_sales AS (select * from subquery746034) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery810679) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery209527) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery858767);

create table subquery780212 as with cross_items AS (select * from subquery335661), avg_sales AS (select * from subquery746034) SELECT 'store' AS channel, i_brand_id, i_class_id, i_category_id, SUM(ss_quantity * ss_list_price) AS sales, COUNT(*) AS number_sales FROM store_sales, item, date_dim WHERE ss_item_sk IN (select * from subquery810679) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_week_seq = (select * from subquery428029) GROUP BY i_brand_id, i_class_id, i_category_id HAVING SUM(ss_quantity * ss_list_price) > (select * from subquery858767);

create table subquery528895 as with cross_items AS (select * from subquery335661), avg_sales AS (select * from subquery746034) SELECT this_year.channel AS ty_channel, this_year.i_brand_id AS ty_brand, this_year.i_class_id AS ty_class, this_year.i_category_id AS ty_category, this_year.sales AS ty_sales, this_year.number_sales AS ty_number_sales, last_year.channel AS ly_channel, last_year.i_brand_id AS ly_brand, last_year.i_class_id AS ly_class, last_year.i_category_id AS ly_category, last_year.sales AS ly_sales, last_year.number_sales AS ly_number_sales FROM (select * from subquery780212) AS this_year, (select * from subquery511963) AS last_year WHERE this_year.i_brand_id = last_year.i_brand_id AND this_year.i_class_id = last_year.i_class_id AND this_year.i_category_id = last_year.i_category_id ORDER BY this_year.channel, this_year.i_brand_id, this_year.i_class_id, this_year.i_category_id;

WITH cross_items AS (select * from subquery335661), avg_sales AS (select * from subquery746034) SELECT * FROM (select * from subquery528895) WHERE rownum <= 100;

