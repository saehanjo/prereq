create table subquery81008 as SELECT SUM(cs_ext_discount_amt) AS "excess discount amount" FROM catalog_sales, item, date_dim WHERE i_manufact_id = 246 AND i_item_sk = cs_item_sk AND d_date BETWEEN '1999-03-26' AND (CAST('1999-03-26' AS DATE) + 90) AND d_date_sk = cs_sold_date_sk AND cs_ext_discount_amt > (SELECT 1.3 * AVG(cs_ext_discount_amt) FROM catalog_sales, date_dim WHERE cs_item_sk = i_item_sk AND d_date BETWEEN '1999-03-26' AND (CAST('1999-03-26' AS DATE) + 90) AND d_date_sk = cs_sold_date_sk);

SELECT * FROM (select * from subquery81008) WHERE rownum <= 100;

