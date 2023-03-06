create table subquery595860 as SELECT SUM(cs_ext_discount_amt) AS "excess discount amount" FROM catalog_sales, item, date_dim WHERE i_manufact_id = 736 AND i_item_sk = cs_item_sk AND d_date BETWEEN '2001-03-16' AND (CAST('2001-03-16' AS DATE) + 90) AND d_date_sk = cs_sold_date_sk AND cs_ext_discount_amt > (SELECT 1.3 * AVG(cs_ext_discount_amt) FROM catalog_sales, date_dim WHERE cs_item_sk = i_item_sk AND d_date BETWEEN '2001-03-16' AND (CAST('2001-03-16' AS DATE) + 90) AND d_date_sk = cs_sold_date_sk);

SELECT * FROM (select * from subquery595860) WHERE rownum <= 100;

