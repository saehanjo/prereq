create table subquery348536 as SELECT ss_store_sk, ss_item_sk, SUM(ss_sales_price) AS revenue FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1204 AND 1204 + 11 GROUP BY ss_store_sk, ss_item_sk;

create table subquery594904 as select * from subquery348536;

create table subquery48072 as SELECT ss_store_sk, AVG(revenue) AS ave FROM (select * from subquery594904) AS sa GROUP BY ss_store_sk;

create table subquery660158 as SELECT s_store_name, i_item_desc, sc.revenue, i_current_price, i_wholesale_cost, i_brand FROM store, item, (select * from subquery48072) AS sb, (select * from subquery594904) AS sc WHERE sb.ss_store_sk = sc.ss_store_sk AND sc.revenue <= 0.1 * sb.ave AND s_store_sk = sc.ss_store_sk AND i_item_sk = sc.ss_item_sk ORDER BY s_store_name, i_item_desc;

SELECT * FROM (select * from subquery660158) WHERE rownum <= 100;

