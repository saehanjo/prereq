create table subquery687968 as SELECT ws_item_sk AS item_sk, d_date, SUM(SUM(ws_sales_price)) OVER(PARTITION BY ws_item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS cume_sales FROM web_sales, date_dim WHERE ws_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1187 AND 1187 + 11 AND NOT ws_item_sk IS NULL GROUP BY ws_item_sk, d_date;

create table subquery584597 as SELECT ss_item_sk AS item_sk, d_date, SUM(SUM(ss_sales_price)) OVER(PARTITION BY ss_item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS cume_sales FROM store_sales, date_dim WHERE ss_sold_date_sk = d_date_sk AND d_month_seq BETWEEN 1187 AND 1187 + 11 AND NOT ss_item_sk IS NULL GROUP BY ss_item_sk, d_date;

create table subquery719997 as with web_v1 AS (select * from subquery687968), store_v1 AS (select * from subquery584597) SELECT CASE WHEN NOT web.item_sk IS NULL THEN web.item_sk ELSE store.item_sk END AS item_sk, CASE WHEN NOT web.d_date IS NULL THEN web.d_date ELSE store.d_date END AS d_date, web.cume_sales AS web_sales, store.cume_sales AS store_sales FROM web_v1 AS web FULL OUTER JOIN store_v1 AS store ON (web.item_sk = store.item_sk AND web.d_date = store.d_date);

create table subquery424375 as with web_v1 AS (select * from subquery687968), store_v1 AS (select * from subquery584597) SELECT item_sk, d_date, web_sales, store_sales, MAX(web_sales) OVER(PARTITION BY item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS web_cumulative, MAX(store_sales) OVER(PARTITION BY item_sk ORDER BY d_date rows BETWEEN unbounded preceding AND current row) AS store_cumulative FROM (select * from subquery719997) AS x;

create table subquery758075 as with web_v1 AS (select * from subquery687968), store_v1 AS (select * from subquery584597) SELECT * FROM (select * from subquery424375) AS y WHERE web_cumulative > store_cumulative ORDER BY item_sk, d_date;

WITH web_v1 AS (select * from subquery687968), store_v1 AS (select * from subquery584597) SELECT * FROM (select * from subquery758075) WHERE rownum <= 100;

