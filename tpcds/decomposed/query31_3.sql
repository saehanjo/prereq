create table subquery84292 as SELECT AVG(ss_list_price) AS B6_LP, COUNT(ss_list_price) AS B6_CNT, COUNT(DISTINCT ss_list_price) AS B6_CNTD FROM store_sales WHERE ss_quantity BETWEEN 26 AND 30 AND (ss_list_price BETWEEN 28 AND 28 + 10 OR ss_coupon_amt BETWEEN 10807 AND 10807 + 1000 OR ss_wholesale_cost BETWEEN 4 AND 4 + 20);

create table subquery933021 as SELECT AVG(ss_list_price) AS B5_LP, COUNT(ss_list_price) AS B5_CNT, COUNT(DISTINCT ss_list_price) AS B5_CNTD FROM store_sales WHERE ss_quantity BETWEEN 21 AND 25 AND (ss_list_price BETWEEN 97 AND 97 + 10 OR ss_coupon_amt BETWEEN 8016 AND 8016 + 1000 OR ss_wholesale_cost BETWEEN 41 AND 41 + 20);

create table subquery674508 as SELECT AVG(ss_list_price) AS B4_LP, COUNT(ss_list_price) AS B4_CNT, COUNT(DISTINCT ss_list_price) AS B4_CNTD FROM store_sales WHERE ss_quantity BETWEEN 16 AND 20 AND (ss_list_price BETWEEN 80 AND 80 + 10 OR ss_coupon_amt BETWEEN 17797 AND 17797 + 1000 OR ss_wholesale_cost BETWEEN 75 AND 75 + 20);

create table subquery627197 as SELECT AVG(ss_list_price) AS B3_LP, COUNT(ss_list_price) AS B3_CNT, COUNT(DISTINCT ss_list_price) AS B3_CNTD FROM store_sales WHERE ss_quantity BETWEEN 11 AND 15 AND (ss_list_price BETWEEN 73 AND 73 + 10 OR ss_coupon_amt BETWEEN 1592 AND 1592 + 1000 OR ss_wholesale_cost BETWEEN 2 AND 2 + 20);

create table subquery723991 as SELECT AVG(ss_list_price) AS B2_LP, COUNT(ss_list_price) AS B2_CNT, COUNT(DISTINCT ss_list_price) AS B2_CNTD FROM store_sales WHERE ss_quantity BETWEEN 6 AND 10 AND (ss_list_price BETWEEN 3 AND 3 + 10 OR ss_coupon_amt BETWEEN 5103 AND 5103 + 1000 OR ss_wholesale_cost BETWEEN 49 AND 49 + 20);

create table subquery318307 as SELECT AVG(ss_list_price) AS B1_LP, COUNT(ss_list_price) AS B1_CNT, COUNT(DISTINCT ss_list_price) AS B1_CNTD FROM store_sales WHERE ss_quantity BETWEEN 0 AND 5 AND (ss_list_price BETWEEN 33 AND 33 + 10 OR ss_coupon_amt BETWEEN 3749 AND 3749 + 1000 OR ss_wholesale_cost BETWEEN 24 AND 24 + 20);

create table subquery192457 as SELECT * FROM (select * from subquery318307) AS B1, (select * from subquery723991) AS B2, (select * from subquery627197) AS B3, (select * from subquery674508) AS B4, (select * from subquery933021) AS B5, (select * from subquery84292) AS B6;

SELECT * FROM (select * from subquery192457) WHERE rownum <= 100;

