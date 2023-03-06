create table subquery117653 as SELECT i_item_id FROM item WHERE i_item_sk IN (3, 17, 5, 23, 13, 2, 19);

create table subquery550410 as SELECT ca_zip, ca_city, SUM(ws_sales_price) FROM web_sales, customer, customer_address, date_dim, item WHERE ws_bill_customer_sk = c_customer_sk AND c_current_addr_sk = ca_address_sk AND ws_item_sk = i_item_sk AND (SUBSTR(ca_zip, 1, 5) IN ('83405', '85669') OR i_item_id IN (select * from subquery117653)) AND ws_sold_date_sk = d_date_sk AND d_qoy = 2 AND d_year = 2000 GROUP BY ca_zip, ca_city ORDER BY ca_zip, ca_city;

SELECT * FROM (select * from subquery550410) WHERE rownum <= 100;

