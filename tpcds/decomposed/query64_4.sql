create table subquery883222 as SELECT i_item_id FROM item WHERE i_category IN ('Shoes');

create table subquery407642 as select * from subquery883222;

create table subquery730096 as select * from subquery407642;

create table subquery409603 as SELECT i_item_id, SUM(ss_ext_sales_price) AS total_sales FROM store_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery730096) AND ss_item_sk = i_item_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2002 AND d_moy = 10 AND ss_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery76523 as SELECT i_item_id, SUM(cs_ext_sales_price) AS total_sales FROM catalog_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery730096) AND cs_item_sk = i_item_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2002 AND d_moy = 10 AND cs_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery170002 as SELECT i_item_id, SUM(ws_ext_sales_price) AS total_sales FROM web_sales, date_dim, customer_address, item WHERE i_item_id IN (select * from subquery730096) AND ws_item_sk = i_item_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2002 AND d_moy = 10 AND ws_bill_addr_sk = ca_address_sk AND ca_gmt_offset = -5 GROUP BY i_item_id;

create table subquery51226 as with ws AS (select * from subquery170002) SELECT * FROM ws;

create table subquery667874 as with cs AS (select * from subquery76523) SELECT * FROM cs;

create table subquery147794 as with ss AS (select * from subquery409603) SELECT * FROM ss;

create table subquery841894 as with ss AS (select * from subquery409603), cs AS (select * from subquery76523), ws AS (select * from subquery170002) SELECT i_item_id, SUM(total_sales) AS total_sales FROM (select * from subquery147794 UNION ALL select * from subquery667874 UNION ALL select * from subquery51226) AS tmp1 GROUP BY i_item_id ORDER BY i_item_id, total_sales;

WITH ss AS (select * from subquery409603), cs AS (select * from subquery76523), ws AS (select * from subquery170002) SELECT * FROM (select * from subquery841894) WHERE rownum <= 100;

