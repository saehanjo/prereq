create table subquery503846 as SELECT AVG(ss_net_profit) AS rank_col FROM store_sales WHERE ss_store_sk = 4 AND ss_customer_sk IS NULL GROUP BY ss_store_sk;

create table subquery319621 as select * from subquery503846;

create table subquery492715 as SELECT ss_item_sk AS item_sk, AVG(ss_net_profit) AS rank_col FROM store_sales AS ss1 WHERE ss_store_sk = 4 GROUP BY ss_item_sk HAVING AVG(ss_net_profit) > 0.9 * (select * from subquery319621);

create table subquery499103 as select * from subquery492715;

create table subquery25173 as SELECT item_sk, RANK() OVER(ORDER BY rank_col DESC) AS rnk FROM (select * from subquery499103) AS V2;

create table subquery520279 as SELECT item_sk, RANK() OVER(ORDER BY rank_col) AS rnk FROM (select * from subquery499103) AS V1;

create table subquery461 as SELECT * FROM (select * from subquery25173) AS V21 WHERE rnk < 11;

create table subquery670015 as SELECT * FROM (select * from subquery520279) AS V11 WHERE rnk < 11;

create table subquery317767 as SELECT asceding.rnk, i1.i_product_name AS best_performing, i2.i_product_name AS worst_performing FROM (select * from subquery670015) AS asceding, (select * from subquery461) AS descending, item AS i1, item AS i2 WHERE asceding.rnk = descending.rnk AND i1.i_item_sk = asceding.item_sk AND i2.i_item_sk = descending.item_sk ORDER BY asceding.rnk;

SELECT * FROM (select * from subquery317767) WHERE rownum <= 100;

