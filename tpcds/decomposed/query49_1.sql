create table subquery10297 as SELECT i_item_id FROM item WHERE i_item_sk IN (2, 5, 17, 13, 23);

create table subquery232508 as SELECT ca_zip, ca_state, SUM(ws_sales_price) FROM web_sales, customer, customer_address, date_dim, item WHERE ws_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND ws_item_sk = i_item_sk AND (SUBSTR(ca_zip, 1, 5) IN ('83405', '85669', '85392') OR i_item_id IN (select * from subquery10297)) AND ws_sold_date_sk = d_date_sk AND d_qoy = 2 AND d_year = 1999 GROUP BY ca_zip, ca_state ORDER BY ca_zip, ca_state;

SELECT * FROM (select * from subquery232508) WHERE rownum <= 100;

