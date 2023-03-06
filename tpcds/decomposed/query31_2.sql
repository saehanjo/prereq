create table subquery498704 as SELECT AVG(ss_list_price) AS B6_LP, COUNT(ss_list_price) AS B6_CNT, COUNT(DISTINCT ss_list_price) AS B6_CNTD FROM store_sales WHERE ss_quantity BETWEEN 26 AND 30 AND (ss_list_price BETWEEN 23 AND 23 + 10 OR ss_coupon_amt BETWEEN 10239 AND 10239 + 1000 OR ss_wholesale_cost BETWEEN 38 AND 38 + 20);

create table subquery724894 as SELECT AVG(ss_list_price) AS B5_LP, COUNT(ss_list_price) AS B5_CNT, COUNT(DISTINCT ss_list_price) AS B5_CNTD FROM store_sales WHERE ss_quantity BETWEEN 21 AND 25 AND (ss_list_price BETWEEN 177 AND 177 + 10 OR ss_coupon_amt BETWEEN 5248 AND 5248 + 1000 OR ss_wholesale_cost BETWEEN 57 AND 57 + 20);

create table subquery435089 as SELECT AVG(ss_list_price) AS B4_LP, COUNT(ss_list_price) AS B4_CNT, COUNT(DISTINCT ss_list_price) AS B4_CNTD FROM store_sales WHERE ss_quantity BETWEEN 16 AND 20 AND (ss_list_price BETWEEN 92 AND 92 + 10 OR ss_coupon_amt BETWEEN 13923 AND 13923 + 1000 OR ss_wholesale_cost BETWEEN 16 AND 16 + 20);

create table subquery719331 as SELECT AVG(ss_list_price) AS B3_LP, COUNT(ss_list_price) AS B3_CNT, COUNT(DISTINCT ss_list_price) AS B3_CNTD FROM store_sales WHERE ss_quantity BETWEEN 11 AND 15 AND (ss_list_price BETWEEN 180 AND 180 + 10 OR ss_coupon_amt BETWEEN 8485 AND 8485 + 1000 OR ss_wholesale_cost BETWEEN 15 AND 15 + 20);

create table subquery231287 as SELECT AVG(ss_list_price) AS B2_LP, COUNT(ss_list_price) AS B2_CNT, COUNT(DISTINCT ss_list_price) AS B2_CNTD FROM store_sales WHERE ss_quantity BETWEEN 6 AND 10 AND (ss_list_price BETWEEN 112 AND 112 + 10 OR ss_coupon_amt BETWEEN 15311 AND 15311 + 1000 OR ss_wholesale_cost BETWEEN 73 AND 73 + 20);

create table subquery664223 as SELECT AVG(ss_list_price) AS B1_LP, COUNT(ss_list_price) AS B1_CNT, COUNT(DISTINCT ss_list_price) AS B1_CNTD FROM store_sales WHERE ss_quantity BETWEEN 0 AND 5 AND (ss_list_price BETWEEN 7 AND 7 + 10 OR ss_coupon_amt BETWEEN 755 AND 755 + 1000 OR ss_wholesale_cost BETWEEN 49 AND 49 + 20);

create table subquery388849 as SELECT * FROM (select * from subquery664223) AS B1, (select * from subquery231287) AS B2, (select * from subquery719331) AS B3, (select * from subquery435089) AS B4, (select * from subquery724894) AS B5, (select * from subquery498704) AS B6;

SELECT * FROM (select * from subquery388849) WHERE rownum <= 100;

