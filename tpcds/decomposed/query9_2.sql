create table subquery451903 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery323234 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery353750 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery417893 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery135415 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery725410 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery514344 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery982727 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery833638 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery685362 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery529693 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery998616 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery717257 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery299765 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery828327 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

SELECT CASE WHEN (select * from subquery135415) > 26128 THEN (select * from subquery685362) ELSE (select * from subquery828327) END AS bucket1, CASE WHEN (select * from subquery417893) > 12481 THEN (select * from subquery833638) ELSE (select * from subquery299765) END AS bucket2, CASE WHEN (select * from subquery353750) > 10280 THEN (select * from subquery982727) ELSE (select * from subquery717257) END AS bucket3, CASE WHEN (select * from subquery323234) > 15876 THEN (select * from subquery514344) ELSE (select * from subquery998616) END AS bucket4, CASE WHEN (select * from subquery451903) > 15521 THEN (select * from subquery725410) ELSE (select * from subquery529693) END AS bucket5 FROM reason WHERE r_reason_sk = 1;

