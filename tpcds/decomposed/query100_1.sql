create table subquery639544 as SELECT COUNT(*) FROM store_sales, household_demographics, time_dim, store WHERE ss_sold_time_sk = time_dim.t_time_sk AND ss_hdemo_sk = household_demographics.hd_demo_sk AND ss_store_sk = s_store_sk AND time_dim.t_hour = 20 AND time_dim.t_minute >= 30 AND household_demographics.hd_dep_count = 6 AND store.s_store_name = 'ese' ORDER BY COUNT(*);

SELECT * FROM (select * from subquery639544) WHERE rownum <= 100;

