create table subquery408067 as SELECT COUNT(*) AS pmc FROM web_sales, household_demographics, time_dim, web_page WHERE ws_sold_time_sk = time_dim.t_time_sk AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk AND ws_web_page_sk = web_page.wp_web_page_sk AND time_dim.t_hour BETWEEN 21 AND 21 + 1 AND household_demographics.hd_dep_count = 9 AND web_page.wp_char_count BETWEEN 5000 AND 5200;

create table subquery375815 as SELECT COUNT(*) AS amc FROM web_sales, household_demographics, time_dim, web_page WHERE ws_sold_time_sk = time_dim.t_time_sk AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk AND ws_web_page_sk = web_page.wp_web_page_sk AND time_dim.t_hour BETWEEN 6 AND 6 + 1 AND household_demographics.hd_dep_count = 9 AND web_page.wp_char_count BETWEEN 5000 AND 5200;

create table subquery28340 as SELECT CAST(amc AS DECIMAL(15, 4)) / CAST(pmc AS DECIMAL(15, 4)) AS am_pm_ratio FROM (select * from subquery375815) AS at, (select * from subquery408067) AS pt ORDER BY am_pm_ratio;

SELECT * FROM (select * from subquery28340) WHERE rownum <= 100;

