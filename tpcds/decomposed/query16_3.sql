create table subquery804537 as SELECT ca_zip, SUM(cs_sales_price) FROM catalog_sales, customer, customer_address, date_dim WHERE cs_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND (SUBSTR(ca_zip, 1, 5) IN ('86475', '85669') OR ca_state IN ('GA') OR cs_sales_price > 500) AND cs_sold_date_sk = d_date_sk AND d_qoy = 2 AND d_year = 2001 GROUP BY ca_zip ORDER BY ca_zip;

SELECT * FROM (select * from subquery804537) WHERE rownum <= 100;

