create table subquery908095 as SELECT i_item_id FROM item WHERE i_item_sk IN (7, 11, 29, 2, 13, 5, 3, 17);

create table subquery710408 as SELECT ca_zip, ca_city, SUM(ws_sales_price) FROM web_sales, customer, customer_address, date_dim, item WHERE ws_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND ws_item_sk = i_item_sk AND (SUBSTR(ca_zip, 1, 5) IN ('88274', '86197', '85669', '85460', '80348', '86475', '83405', '85392', '81792') OR i_item_id IN (select * from subquery908095)) AND ws_sold_date_sk = d_date_sk AND d_qoy = 1 AND d_year = 2000 GROUP BY ca_zip, ca_city ORDER BY ca_zip, ca_city;

SELECT * FROM (select * from subquery710408) WHERE rownum <= 100;

