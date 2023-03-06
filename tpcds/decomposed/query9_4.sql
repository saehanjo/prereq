create table subquery119888 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery521748 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery66385 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery418827 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery210648 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery912937 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery155992 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery914066 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery376735 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery970926 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery190987 as SELECT AVG(ss_net_paid) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery2642 as SELECT AVG(ss_net_paid) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery360975 as SELECT AVG(ss_net_paid) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery352665 as SELECT AVG(ss_net_paid) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery388551 as SELECT AVG(ss_net_paid) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

SELECT CASE WHEN (select * from subquery210648) > 40607 THEN (select * from subquery970926) ELSE (select * from subquery388551) END AS bucket1, CASE WHEN (select * from subquery418827) > 1470 THEN (select * from subquery376735) ELSE (select * from subquery352665) END AS bucket2, CASE WHEN (select * from subquery66385) > 35042 THEN (select * from subquery914066) ELSE (select * from subquery360975) END AS bucket3, CASE WHEN (select * from subquery521748) > 28887 THEN (select * from subquery155992) ELSE (select * from subquery2642) END AS bucket4, CASE WHEN (select * from subquery119888) > 22286 THEN (select * from subquery912937) ELSE (select * from subquery190987) END AS bucket5 FROM reason WHERE r_reason_sk = 1;

