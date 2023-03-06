create table subquery167894 as SELECT AVG(ss_net_profit) AS rank_col FROM store_sales WHERE ss_store_sk = 6 AND ss_addr_sk IS NULL GROUP BY ss_store_sk;

create table subquery123342 as select * from subquery167894;

create table subquery292145 as SELECT ss_item_sk AS item_sk, AVG(ss_net_profit) AS rank_col FROM store_sales AS ss1 WHERE ss_store_sk = 6 GROUP BY ss_item_sk HAVING AVG(ss_net_profit) > 0.9 * (select * from subquery123342);

create table subquery694153 as select * from subquery292145;

create table subquery544916 as SELECT item_sk, RANK() OVER(ORDER BY rank_col DESC) AS rnk FROM (select * from subquery694153) AS V2;

create table subquery961567 as SELECT item_sk, RANK() OVER(ORDER BY rank_col) AS rnk FROM (select * from subquery694153) AS V1;

create table subquery658335 as SELECT * FROM (select * from subquery544916) AS V21 WHERE rnk < 11;

create table subquery498656 as SELECT * FROM (select * from subquery961567) AS V11 WHERE rnk < 11;

create table subquery12327 as SELECT asceding.rnk, i1.i_product_name AS best_performing, i2.i_product_name AS worst_performing FROM (select * from subquery498656) AS asceding, (select * from subquery658335) AS descending, item AS i1, item AS i2 WHERE asceding.rnk = descending.rnk AND i1.i_item_sk = asceding.item_sk AND i2.i_item_sk = descending.item_sk ORDER BY asceding.rnk;

SELECT * FROM (select * from subquery12327) WHERE rownum <= 100;

