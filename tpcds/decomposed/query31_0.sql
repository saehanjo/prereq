create table subquery570752 as SELECT AVG(ss_list_price) AS B6_LP, COUNT(ss_list_price) AS B6_CNT, COUNT(DISTINCT ss_list_price) AS B6_CNTD FROM store_sales WHERE ss_quantity BETWEEN 26 AND 30 AND (ss_list_price BETWEEN 64 AND 64 + 10 OR ss_coupon_amt BETWEEN 5792 AND 5792 + 1000 OR ss_wholesale_cost BETWEEN 73 AND 73 + 20);

create table subquery298578 as SELECT AVG(ss_list_price) AS B5_LP, COUNT(ss_list_price) AS B5_CNT, COUNT(DISTINCT ss_list_price) AS B5_CNTD FROM store_sales WHERE ss_quantity BETWEEN 21 AND 25 AND (ss_list_price BETWEEN 58 AND 58 + 10 OR ss_coupon_amt BETWEEN 9402 AND 9402 + 1000 OR ss_wholesale_cost BETWEEN 38 AND 38 + 20);

create table subquery19804 as SELECT AVG(ss_list_price) AS B4_LP, COUNT(ss_list_price) AS B4_CNT, COUNT(DISTINCT ss_list_price) AS B4_CNTD FROM store_sales WHERE ss_quantity BETWEEN 16 AND 20 AND (ss_list_price BETWEEN 89 AND 89 + 10 OR ss_coupon_amt BETWEEN 3117 AND 3117 + 1000 OR ss_wholesale_cost BETWEEN 68 AND 68 + 20);

create table subquery775325 as SELECT AVG(ss_list_price) AS B3_LP, COUNT(ss_list_price) AS B3_CNT, COUNT(DISTINCT ss_list_price) AS B3_CNTD FROM store_sales WHERE ss_quantity BETWEEN 11 AND 15 AND (ss_list_price BETWEEN 74 AND 74 + 10 OR ss_coupon_amt BETWEEN 4381 AND 4381 + 1000 OR ss_wholesale_cost BETWEEN 57 AND 57 + 20);

create table subquery941404 as SELECT AVG(ss_list_price) AS B2_LP, COUNT(ss_list_price) AS B2_CNT, COUNT(DISTINCT ss_list_price) AS B2_CNTD FROM store_sales WHERE ss_quantity BETWEEN 6 AND 10 AND (ss_list_price BETWEEN 23 AND 23 + 10 OR ss_coupon_amt BETWEEN 825 AND 825 + 1000 OR ss_wholesale_cost BETWEEN 43 AND 43 + 20);

create table subquery933550 as SELECT AVG(ss_list_price) AS B1_LP, COUNT(ss_list_price) AS B1_CNT, COUNT(DISTINCT ss_list_price) AS B1_CNTD FROM store_sales WHERE ss_quantity BETWEEN 0 AND 5 AND (ss_list_price BETWEEN 107 AND 107 + 10 OR ss_coupon_amt BETWEEN 1319 AND 1319 + 1000 OR ss_wholesale_cost BETWEEN 60 AND 60 + 20);

create table subquery952294 as SELECT * FROM (select * from subquery933550) AS B1, (select * from subquery941404) AS B2, (select * from subquery775325) AS B3, (select * from subquery19804) AS B4, (select * from subquery298578) AS B5, (select * from subquery570752) AS B6;

SELECT * FROM (select * from subquery952294) WHERE rownum <= 100;

