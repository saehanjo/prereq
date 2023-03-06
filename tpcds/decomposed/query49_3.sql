create table subquery894471 as SELECT i_item_id FROM item WHERE i_item_sk IN (19, 13, 2, 17, 11, 29, 23, 3, 5, 7);

create table subquery407529 as SELECT ca_zip, ca_state, SUM(ws_sales_price) FROM web_sales, customer, customer_address, date_dim, item WHERE ws_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND ws_item_sk = i_item_sk AND (SUBSTR(ca_zip, 1, 5) IN ('85460', '88274', '86197', '81792', '85392') OR i_item_id IN (select * from subquery894471)) AND ws_sold_date_sk = d_date_sk AND d_qoy = 2 AND d_year = 1999 GROUP BY ca_zip, ca_state ORDER BY ca_zip, ca_state;

SELECT * FROM (select * from subquery407529) WHERE rownum <= 100;

