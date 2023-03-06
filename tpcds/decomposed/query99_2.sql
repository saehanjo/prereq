create table subquery809998 as SELECT ws1.ws_order_number, ws1.ws_warehouse_sk AS wh1, ws2.ws_warehouse_sk AS wh2 FROM web_sales AS ws1, web_sales AS ws2 WHERE ws1.ws_order_number = ws2.ws_order_number AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk;

create table subquery337785 as with ws_wh AS (select * from subquery809998) SELECT ws_order_number FROM ws_wh;

create table subquery694398 as with ws_wh AS (select * from subquery809998) SELECT wr_order_number FROM web_returns, ws_wh WHERE wr_order_number = ws_wh.ws_order_number;

create table subquery338496 as with ws_wh AS (select * from subquery809998) SELECT COUNT(DISTINCT ws_order_number) AS "order count", SUM(ws_ext_ship_cost) AS "total shipping cost", SUM(ws_net_profit) AS "total net profit" FROM web_sales AS ws1, date_dim, customer_address, web_site WHERE d_date BETWEEN '2000-3-01' AND (CAST('2000-3-01' AS DATE) + 60) AND ws1.ws_ship_date_sk = d_date_sk AND ws1.ws_ship_addr_sk = ca_address_sk AND ca_state = 'MO' AND ws1.ws_web_site_sk = web_site_sk AND web_company_name = 'pri' AND ws1.ws_order_number IN (select * from subquery337785) AND ws1.ws_order_number IN (select * from subquery694398) ORDER BY COUNT(DISTINCT ws_order_number);

WITH ws_wh AS (select * from subquery809998) SELECT * FROM (select * from subquery338496) WHERE rownum <= 100;

