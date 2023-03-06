create table subquery77353 as SELECT AVG(ss_list_price) AS B6_LP, COUNT(ss_list_price) AS B6_CNT, COUNT(DISTINCT ss_list_price) AS B6_CNTD FROM store_sales WHERE ss_quantity BETWEEN 26 AND 30 AND (ss_list_price BETWEEN 47 AND 47 + 10 OR ss_coupon_amt BETWEEN 5858 AND 5858 + 1000 OR ss_wholesale_cost BETWEEN 18 AND 18 + 20);

create table subquery98890 as SELECT AVG(ss_list_price) AS B5_LP, COUNT(ss_list_price) AS B5_CNT, COUNT(DISTINCT ss_list_price) AS B5_CNTD FROM store_sales WHERE ss_quantity BETWEEN 21 AND 25 AND (ss_list_price BETWEEN 185 AND 185 + 10 OR ss_coupon_amt BETWEEN 11283 AND 11283 + 1000 OR ss_wholesale_cost BETWEEN 32 AND 32 + 20);

create table subquery944049 as SELECT AVG(ss_list_price) AS B4_LP, COUNT(ss_list_price) AS B4_CNT, COUNT(DISTINCT ss_list_price) AS B4_CNTD FROM store_sales WHERE ss_quantity BETWEEN 16 AND 20 AND (ss_list_price BETWEEN 102 AND 102 + 10 OR ss_coupon_amt BETWEEN 367 AND 367 + 1000 OR ss_wholesale_cost BETWEEN 59 AND 59 + 20);

create table subquery835568 as SELECT AVG(ss_list_price) AS B3_LP, COUNT(ss_list_price) AS B3_CNT, COUNT(DISTINCT ss_list_price) AS B3_CNTD FROM store_sales WHERE ss_quantity BETWEEN 11 AND 15 AND (ss_list_price BETWEEN 98 AND 98 + 10 OR ss_coupon_amt BETWEEN 1803 AND 1803 + 1000 OR ss_wholesale_cost BETWEEN 23 AND 23 + 20);

create table subquery438090 as SELECT AVG(ss_list_price) AS B2_LP, COUNT(ss_list_price) AS B2_CNT, COUNT(DISTINCT ss_list_price) AS B2_CNTD FROM store_sales WHERE ss_quantity BETWEEN 6 AND 10 AND (ss_list_price BETWEEN 115 AND 115 + 10 OR ss_coupon_amt BETWEEN 4725 AND 4725 + 1000 OR ss_wholesale_cost BETWEEN 42 AND 42 + 20);

create table subquery33237 as SELECT AVG(ss_list_price) AS B1_LP, COUNT(ss_list_price) AS B1_CNT, COUNT(DISTINCT ss_list_price) AS B1_CNTD FROM store_sales WHERE ss_quantity BETWEEN 0 AND 5 AND (ss_list_price BETWEEN 36 AND 36 + 10 OR ss_coupon_amt BETWEEN 16650 AND 16650 + 1000 OR ss_wholesale_cost BETWEEN 16 AND 16 + 20);

create table subquery216944 as SELECT * FROM (select * from subquery33237) AS B1, (select * from subquery438090) AS B2, (select * from subquery835568) AS B3, (select * from subquery944049) AS B4, (select * from subquery98890) AS B5, (select * from subquery77353) AS B6;

SELECT * FROM (select * from subquery216944) WHERE rownum <= 100;

