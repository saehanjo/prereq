create table subquery375538 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery533791 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery602148 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery848788 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery154155 as SELECT COUNT(*) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery976383 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery421756 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery69021 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery884915 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery899563 as SELECT AVG(ss_ext_tax) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

create table subquery391814 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 81 AND 100;

create table subquery86330 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 61 AND 80;

create table subquery186005 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 41 AND 60;

create table subquery515861 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 21 AND 40;

create table subquery693238 as SELECT AVG(ss_net_paid_inc_tax) FROM store_sales WHERE ss_quantity BETWEEN 1 AND 20;

SELECT CASE WHEN (select * from subquery154155) > 1071 THEN (select * from subquery899563) ELSE (select * from subquery693238) END AS bucket1, CASE WHEN (select * from subquery848788) > 39161 THEN (select * from subquery884915) ELSE (select * from subquery515861) END AS bucket2, CASE WHEN (select * from subquery602148) > 29434 THEN (select * from subquery69021) ELSE (select * from subquery186005) END AS bucket3, CASE WHEN (select * from subquery533791) > 6568 THEN (select * from subquery421756) ELSE (select * from subquery86330) END AS bucket4, CASE WHEN (select * from subquery375538) > 21216 THEN (select * from subquery976383) ELSE (select * from subquery391814) END AS bucket5 FROM reason WHERE r_reason_sk = 1;

