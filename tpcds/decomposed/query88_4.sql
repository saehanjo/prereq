create table subquery634992 as SELECT c_customer_id AS customer_id, COALESCE(c_last_name, '') || ', ' || COALESCE(c_first_name, '') AS customername FROM customer, customer_address, customer_demographics, household_demographics, income_band, store_returns WHERE ca_city = 'Providence' AND c_current_addr_sk = ca_address_sk AND ib_lower_bound >= 1787 AND ib_upper_bound <= 1787 + 50000 AND ib_income_band_sk = hd_income_band_sk AND cd_demo_sk = c_current_cdemo_sk AND hd_demo_sk = c_current_hdemo_sk AND sr_cdemo_sk = cd_demo_sk ORDER BY c_customer_id;

SELECT * FROM (select * from subquery634992) WHERE rownum <= 100;

