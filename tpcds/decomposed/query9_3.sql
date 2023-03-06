create table subquery628921 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery717512 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery630769 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery252545 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery382115 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery667829 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery631069 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery14437 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery440076 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery147003 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery236578 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery288039 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery247171 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery331504 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery277144 as SELECT AVG(ss_net_profit) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

SELECT CASE WHEN (select * from subquery382115) > 33876 THEN (select * from subquery147003) ELSE (select * from subquery277144) END AS bucket1, CASE WHEN (select * from subquery252545) > 25103 THEN (select * from subquery440076) ELSE (select * from subquery331504) END AS bucket2, CASE WHEN (select * from subquery630769) > 1339 THEN (select * from subquery14437) ELSE (select * from subquery247171) END AS bucket3, CASE WHEN (select * from subquery717512) > 1111 THEN (select * from subquery631069) ELSE (select * from subquery288039) END AS bucket4, CASE WHEN (select * from subquery628921) > 16715 THEN (select * from subquery667829) ELSE (select * from subquery236578) END AS bucket5 FROM reason WHERE r_reason_sk = 1;

