create table subquery807846 as SELECT AVG(ss_net_profit) AS rank_col FROM store_sales WHERE ss_store_sk = 2 AND ss_addr_sk IS NULL GROUP BY ss_store_sk;

create table subquery297686 as select * from subquery807846;

create table subquery215745 as SELECT ss_item_sk AS item_sk, AVG(ss_net_profit) AS rank_col FROM store_sales AS ss1 WHERE ss_store_sk = 2 GROUP BY ss_item_sk HAVING AVG(ss_net_profit) > 0.9 * (select * from subquery297686);

create table subquery197790 as select * from subquery215745;

create table subquery220948 as SELECT item_sk, RANK() OVER(ORDER BY rank_col DESC) AS rnk FROM (select * from subquery197790) AS V2;

create table subquery956143 as SELECT item_sk, RANK() OVER(ORDER BY rank_col) AS rnk FROM (select * from subquery197790) AS V1;

create table subquery298521 as SELECT * FROM (select * from subquery220948) AS V21 WHERE rnk < 11;

create table subquery471619 as SELECT * FROM (select * from subquery956143) AS V11 WHERE rnk < 11;

create table subquery80475 as SELECT asceding.rnk, i1.i_product_name AS best_performing, i2.i_product_name AS worst_performing FROM (select * from subquery471619) AS asceding, (select * from subquery298521) AS descending, item AS i1, item AS i2 WHERE asceding.rnk = descending.rnk AND i1.i_item_sk = asceding.item_sk AND i2.i_item_sk = descending.item_sk ORDER BY asceding.rnk;

SELECT * FROM (select * from subquery80475) WHERE rownum <= 100;

