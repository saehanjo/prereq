create table subquery102244 as SELECT ss_ticket_number, ss_customer_sk, store.s_city, SUM(ss_coupon_amt) AS amt, SUM(ss_net_profit) AS profit FROM store_sales, date_dim, store, household_demographics WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk AND store_sales.ss_store_sk = store.s_store_sk AND store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk AND (household_demographics.hd_dep_count = 7 OR household_demographics.hd_vehicle_count > -1) AND date_dim.d_dow = 1 AND date_dim.d_year IN (2000 + 2, 2000, 2000 + 1) AND store.s_number_employees BETWEEN 200 AND 295 GROUP BY ss_ticket_number, ss_customer_sk, ss_addr_sk, store.s_city;

create table subquery358356 as SELECT c_last_name, c_first_name, SUBSTR(s_city, 1, 30), ss_ticket_number, amt, profit FROM (select * from subquery102244) AS ms, customer WHERE ss_customer_sk = c_customer_sk ORDER BY c_last_name, c_first_name, SUBSTR(s_city, 1, 30), profit;

SELECT * FROM (select * from subquery358356) WHERE rownum <= 100;

