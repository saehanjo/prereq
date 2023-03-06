create table subquery779088 as SELECT ss_ticket_number, ss_customer_sk, ca_city AS bought_city, SUM(ss_coupon_amt) AS amt, SUM(ss_net_profit) AS profit FROM store_sales, date_dim, store, household_demographics, customer_address WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk AND store_sales.ss_store_sk = store.s_store_sk AND store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk AND store_sales.ss_addr_sk = customer_address.ca_address_sk AND (household_demographics.hd_dep_count = 8 OR household_demographics.hd_vehicle_count = 0) AND date_dim.d_dow IN (0, 6) AND date_dim.d_year IN (2000 + 2, 2000 + 1) AND store.s_city IN ('Midway') GROUP BY ss_ticket_number, ss_customer_sk, ss_addr_sk, ca_city;

create table subquery353433 as SELECT c_last_name, c_first_name, ca_city, bought_city, ss_ticket_number, amt, profit FROM (select * from subquery779088) AS dn, customer, customer_address AS current_addr WHERE ss_customer_sk = c_customer_sk AND customer.c_current_addr_sk = current_addr.ca_address_sk AND current_addr.ca_city <> bought_city ORDER BY c_last_name, c_first_name, ca_city, bought_city, ss_ticket_number;

SELECT * FROM (select * from subquery353433) WHERE rownum <= 100;

