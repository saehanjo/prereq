create table subquery202181 as SELECT AVG(ss_net_profit) AS rank_col FROM store_sales WHERE ss_store_sk = 4 AND ss_cdemo_sk IS NULL GROUP BY ss_store_sk;

create table subquery713827 as select * from subquery202181;

create table subquery912546 as SELECT ss_item_sk AS item_sk, AVG(ss_net_profit) AS rank_col FROM store_sales AS ss1 WHERE ss_store_sk = 4 GROUP BY ss_item_sk HAVING AVG(ss_net_profit) > 0.9 * (select * from subquery713827);

create table subquery310128 as select * from subquery912546;

create table subquery715409 as SELECT item_sk, RANK() OVER(ORDER BY rank_col DESC) AS rnk FROM (select * from subquery310128) AS V2;

create table subquery230305 as SELECT item_sk, RANK() OVER(ORDER BY rank_col) AS rnk FROM (select * from subquery310128) AS V1;

create table subquery249253 as SELECT * FROM (select * from subquery715409) AS V21 WHERE rnk < 11;

create table subquery273768 as SELECT * FROM (select * from subquery230305) AS V11 WHERE rnk < 11;

create table subquery542381 as SELECT asceding.rnk, i1.i_product_name AS best_performing, i2.i_product_name AS worst_performing FROM (select * from subquery273768) AS asceding, (select * from subquery249253) AS descending, item AS i1, item AS i2 WHERE asceding.rnk = descending.rnk AND i1.i_item_sk = asceding.item_sk AND i2.i_item_sk = descending.item_sk ORDER BY asceding.rnk;

SELECT * FROM (select * from subquery542381) WHERE rownum <= 100;

