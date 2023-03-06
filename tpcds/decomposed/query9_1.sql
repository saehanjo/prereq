create table subquery545663 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery624516 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery304138 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery911425 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery837106 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery168148 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery178235 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery93484 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery862773 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery965214 as SELECT AVG(ss_ext_sales_price) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery726682 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery830846 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery752109 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery830487 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery416156 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

SELECT CASE WHEN (select * from subquery837106) > 1286 THEN (select * from subquery965214) ELSE (select * from subquery416156) END AS bucket1, CASE WHEN (select * from subquery911425) > 24369 THEN (select * from subquery862773) ELSE (select * from subquery830487) END AS bucket2, CASE WHEN (select * from subquery304138) > 41905 THEN (select * from subquery93484) ELSE (select * from subquery752109) END AS bucket3, CASE WHEN (select * from subquery624516) > 31939 THEN (select * from subquery178235) ELSE (select * from subquery830846) END AS bucket4, CASE WHEN (select * from subquery545663) > 33447 THEN (select * from subquery168148) ELSE (select * from subquery726682) END AS bucket5 FROM reason WHERE r_reason_sk = 1;

