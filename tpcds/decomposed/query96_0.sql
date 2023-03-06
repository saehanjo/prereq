create table subquery26368 as SELECT SUM(ws_ext_discount_amt) AS "Excess Discount Amount" FROM web_sales, item, date_dim WHERE i_manufact_id = 714 AND i_item_sk = ws_item_sk AND d_date BETWEEN '2000-02-01' AND (CAST('2000-02-01' AS DATE) + 90) AND d_date_sk = ws_sold_date_sk AND ws_ext_discount_amt > (SELECT 1.3 * AVG(ws_ext_discount_amt) FROM web_sales, date_dim WHERE ws_item_sk = i_item_sk AND d_date BETWEEN '2000-02-01' AND (CAST('2000-02-01' AS DATE) + 90) AND d_date_sk = ws_sold_date_sk) ORDER BY SUM(ws_ext_discount_amt);

SELECT * FROM (select * from subquery26368) WHERE rownum <= 100;

