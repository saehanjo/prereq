create table subquery687063 as SELECT ss_store_sk, ss_item_sk, SUM(ss_sales_price) AS revenue FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1213 AND 1213 + 11 GROUP BY ss_store_sk, ss_item_sk;

create table subquery743297 as select * from subquery687063;

create table subquery423656 as SELECT ss_store_sk, AVG(revenue) AS ave FROM (select * from subquery743297) AS sa GROUP BY ss_store_sk;

create table subquery274732 as SELECT s_store_name, i_item_desc, sc.revenue, i_current_price, i_wholesale_cost, i_brand FROM store, item, (select * from subquery423656) AS sb, (select * from subquery743297) AS sc WHERE sb.ss_store_sk = sc.ss_store_sk AND sc.revenue <= 0.1 * sb.ave AND s_store_sk = sc.ss_store_sk AND i_item_sk = sc.ss_item_sk ORDER BY s_store_name, i_item_desc;

SELECT * FROM (select * from subquery274732) WHERE rownum <= 100;

