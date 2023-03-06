create table subquery781773 as SELECT ws_item_sk AS item_sk, d_date, SUM(SUM(ws_sales_price)) OVER(PARTITION BY ws_item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS cume_sales FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1209 AND 1209 + 11 AND NOT ws_item_sk IS NULL GROUP BY ws_item_sk, d_date;

create table subquery830457 as SELECT ss_item_sk AS item_sk, d_date, SUM(SUM(ss_sales_price)) OVER(PARTITION BY ss_item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS cume_sales FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1209 AND 1209 + 11 AND NOT ss_item_sk IS NULL GROUP BY ss_item_sk, d_date;

create table subquery498542 as with web_v1 AS (select * from subquery781773), store_v1 AS (select * from subquery830457) SELECT CASE WHEN NOT web.item_sk IS NULL THEN web.item_sk ELSE store.item_sk END AS item_sk, CASE WHEN NOT web.d_date IS NULL THEN web.d_date ELSE store.d_date END AS d_date, web.cume_sales AS web_sales, store.cume_sales AS store_sales FROM web_v1 AS web FULL OUTER JOIN store_v1 AS store ON (web.item_sk = store.item_sk AND web.d_date = store.d_date);

create table subquery498381 as with web_v1 AS (select * from subquery781773), store_v1 AS (select * from subquery830457) SELECT item_sk, d_date, web_sales, store_sales, MAX(web_sales) OVER(PARTITION BY item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS web_cumulative, MAX(store_sales) OVER(PARTITION BY item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS store_cumulative FROM (select * from subquery498542) AS x;

create table subquery477756 as with web_v1 AS (select * from subquery781773), store_v1 AS (select * from subquery830457) SELECT * FROM (select * from subquery498381) AS y WHERE web_cumulative > store_cumulative ORDER BY item_sk, d_date;

WITH web_v1 AS (select * from subquery781773), store_v1 AS (select * from subquery830457) SELECT * FROM (select * from subquery477756) WHERE rownum <= 100;

