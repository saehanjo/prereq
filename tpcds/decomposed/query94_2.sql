create table subquery857206 as SELECT COUNT(*) AS pmc FROM web_sales, household_demographics, time_dim, web_page WHERE ws_sold_time_sk = time_dim.t_time_sk AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk AND ws_web_page_sk = web_page.wp_web_page_sk AND time_dim.t_hour BETWEEN 17 AND 17 + 1 AND household_demographics.hd_dep_count = 8 AND web_page.wp_char_count BETWEEN 5000 AND 5200;

create table subquery775731 as SELECT COUNT(*) AS amc FROM web_sales, household_demographics, time_dim, web_page WHERE ws_sold_time_sk = time_dim.t_time_sk AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk AND ws_web_page_sk = web_page.wp_web_page_sk AND time_dim.t_hour BETWEEN 6 AND 6 + 1 AND household_demographics.hd_dep_count = 8 AND web_page.wp_char_count BETWEEN 5000 AND 5200;

create table subquery940152 as SELECT CAST(amc AS DECIMAL(15, 4)) / CAST(pmc AS DECIMAL(15, 4)) AS am_pm_ratio FROM (select * from subquery775731) AS at, (select * from subquery857206) AS pt ORDER BY am_pm_ratio;

SELECT * FROM (select * from subquery940152) WHERE rownum <= 100;

