create table subquery331824 as SELECT s_store_name, s_store_id, SUM(CASE WHEN (d_day_name = 'Sunday') THEN ss_sales_price ELSE NULL END) AS sun_sales, SUM(CASE WHEN (d_day_name = 'Monday') THEN ss_sales_price ELSE NULL END) AS mon_sales, SUM(CASE WHEN (d_day_name = 'Tuesday') THEN ss_sales_price ELSE NULL END) AS tue_sales, SUM(CASE WHEN (d_day_name = 'Wednesday') THEN ss_sales_price ELSE NULL END) AS wed_sales, SUM(CASE WHEN (d_day_name = 'Thursday') THEN ss_sales_price ELSE NULL END) AS thu_sales, SUM(CASE WHEN (d_day_name = 'Friday') THEN ss_sales_price ELSE NULL END) AS fri_sales, SUM(CASE WHEN (d_day_name = 'Saturday') THEN ss_sales_price ELSE NULL END) AS sat_sales FROM date_dim, store_sales, store WHERE d_date_sk = ss_sold_date_sk AND s_store_sk = ss_store_sk AND s_gmt_offset = -5 AND d_year = 1998 GROUP BY s_store_name, s_store_id ORDER BY s_store_name, s_store_id, sun_sales, mon_sales, tue_sales, wed_sales, thu_sales, fri_sales, sat_sales;

SELECT * FROM (select * from subquery331824) WHERE rownum <= 100;

