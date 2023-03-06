create table subquery276571 as SELECT i_item_id FROM item WHERE i_item_sk IN (23, 11);

create table subquery513013 as SELECT ca_zip, ca_city, SUM(ws_sales_price) FROM web_sales, customer, customer_address, date_dim, item WHERE ws_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND ws_item_sk = i_item_sk AND (SUBSTR(ca_zip, 1, 5) IN ('83405', '85669') OR i_item_id IN (select * from subquery276571)) AND ws_sold_date_sk = d_date_sk AND d_qoy = 2 AND d_year = 2000 GROUP BY ca_zip, ca_city ORDER BY ca_zip, ca_city;

SELECT * FROM (select * from subquery513013) WHERE rownum <= 100;

