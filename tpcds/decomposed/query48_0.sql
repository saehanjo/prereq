create table subquery268110 as SELECT AVG(ss_net_profit) AS rank_col FROM store_sales WHERE ss_store_sk = 4 AND ss_hdemo_sk IS NULL GROUP BY ss_store_sk;

create table subquery891203 as select * from subquery268110;

create table subquery227878 as SELECT ss_item_sk AS item_sk, AVG(ss_net_profit) AS rank_col FROM store_sales AS ss1 WHERE ss_store_sk = 4 GROUP BY ss_item_sk HAVING AVG(ss_net_profit) > 0.9 * (select * from subquery891203);

create table subquery62205 as select * from subquery227878;

create table subquery908247 as SELECT item_sk, RANK() OVER(ORDER BY rank_col DESC) AS rnk FROM (select * from subquery62205) AS V2;

create table subquery453837 as SELECT item_sk, RANK() OVER(ORDER BY rank_col) AS rnk FROM (select * from subquery62205) AS V1;

create table subquery709868 as SELECT * FROM (select * from subquery908247) AS V21 WHERE rnk < 11;

create table subquery295543 as SELECT * FROM (select * from subquery453837) AS V11 WHERE rnk < 11;

create table subquery282309 as SELECT asceding.rnk, i1.i_product_name AS best_performing, i2.i_product_name AS worst_performing FROM (select * from subquery295543) AS asceding, (select * from subquery709868) AS descending, item AS i1, item AS i2 WHERE asceding.rnk = descending.rnk AND i1.i_item_sk = asceding.item_sk AND i2.i_item_sk = descending.item_sk ORDER BY asceding.rnk;

SELECT * FROM (select * from subquery282309) WHERE rownum <= 100;

