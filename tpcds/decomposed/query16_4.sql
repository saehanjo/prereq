create table subquery258658 as SELECT ca_zip, SUM(cs_sales_price) FROM catalog_sales, customer, customer_address, date_dim WHERE cs_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND (SUBSTR(ca_zip, 1, 5) IN ('86197', '85392', '85669', '81792', '86475', '80348', '85460') OR ca_state IN ('WA', 'GA') OR cs_sales_price > 500) AND cs_sold_date_sk = d_date_sk AND d_qoy = 1 AND d_year = 1998 GROUP BY ca_zip ORDER BY ca_zip;

SELECT * FROM (select * from subquery258658) WHERE rownum <= 100;

