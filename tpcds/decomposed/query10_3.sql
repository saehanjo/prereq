create table subquery748247 as SELECT cd_gender, cd_marital_status, cd_education_status, COUNT(*) AS cnt1, cd_purchase_estimate, COUNT(*) AS cnt2, cd_credit_rating, COUNT(*) AS cnt3, cd_dep_count, COUNT(*) AS cnt4, cd_dep_employed_count, COUNT(*) AS cnt5, cd_dep_college_count, COUNT(*) AS cnt6 FROM customer AS c, customer_address AS ca, customer_demographics WHERE c.c_current_addr_sk = ca.ca_address_sk AND ca_county IN ('Blaine County', 'Ray County', 'Hettinger County') AND cd_demo_sk = c.c_current_cdemo_sk AND EXISTS(SELECT * FROM store_sales, date_dim WHERE c.c_customer_sk = ss_customer_sk AND ss_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy BETWEEN 1 AND 1 + 3) AND (EXISTS(SELECT * FROM web_sales, date_dim WHERE c.c_customer_sk = ws_bill_customer_sk AND ws_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy BETWEEN 1 AND 1 + 3) OR EXISTS(SELECT * FROM catalog_sales, date_dim WHERE c.c_customer_sk = cs_ship_customer_sk AND cs_sold_date_sk = d_date_sk AND d_year = 2000 AND d_moy BETWEEN 1 AND 1 + 3)) GROUP BY cd_gender, cd_marital_status, cd_education_status, cd_purchase_estimate, cd_credit_rating, cd_dep_count, cd_dep_employed_count, cd_dep_college_count ORDER BY cd_gender, cd_marital_status, cd_education_status, cd_purchase_estimate, cd_credit_rating, cd_dep_count, cd_dep_employed_count, cd_dep_college_count;

SELECT * FROM (select * from subquery748247) WHERE rownum <= 100;

