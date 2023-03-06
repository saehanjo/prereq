create table subquery38335 as SELECT AVG(ss_list_price) AS B6_LP, COUNT(ss_list_price) AS B6_CNT, COUNT(DISTINCT ss_list_price) AS B6_CNTD FROM store_sales WHERE ss_quantity BETWEEN 26 AND 30 AND (ss_list_price BETWEEN 174 AND 174 + 10 OR ss_coupon_amt BETWEEN 1727 AND 1727 + 1000 OR ss_wholesale_cost BETWEEN 4 AND 4 + 20);

create table subquery539650 as SELECT AVG(ss_list_price) AS B5_LP, COUNT(ss_list_price) AS B5_CNT, COUNT(DISTINCT ss_list_price) AS B5_CNTD FROM store_sales WHERE ss_quantity BETWEEN 21 AND 25 AND (ss_list_price BETWEEN 165 AND 165 + 10 OR ss_coupon_amt BETWEEN 7465 AND 7465 + 1000 OR ss_wholesale_cost BETWEEN 61 AND 61 + 20);

create table subquery618386 as SELECT AVG(ss_list_price) AS B4_LP, COUNT(ss_list_price) AS B4_CNT, COUNT(DISTINCT ss_list_price) AS B4_CNTD FROM store_sales WHERE ss_quantity BETWEEN 16 AND 20 AND (ss_list_price BETWEEN 21 AND 21 + 10 OR ss_coupon_amt BETWEEN 15019 AND 15019 + 1000 OR ss_wholesale_cost BETWEEN 36 AND 36 + 20);

create table subquery52789 as SELECT AVG(ss_list_price) AS B3_LP, COUNT(ss_list_price) AS B3_CNT, COUNT(DISTINCT ss_list_price) AS B3_CNTD FROM store_sales WHERE ss_quantity BETWEEN 11 AND 15 AND (ss_list_price BETWEEN 79 AND 79 + 10 OR ss_coupon_amt BETWEEN 9643 AND 9643 + 1000 OR ss_wholesale_cost BETWEEN 74 AND 74 + 20);

create table subquery469772 as SELECT AVG(ss_list_price) AS B2_LP, COUNT(ss_list_price) AS B2_CNT, COUNT(DISTINCT ss_list_price) AS B2_CNTD FROM store_sales WHERE ss_quantity BETWEEN 6 AND 10 AND (ss_list_price BETWEEN 57 AND 57 + 10 OR ss_coupon_amt BETWEEN 425 AND 425 + 1000 OR ss_wholesale_cost BETWEEN 37 AND 37 + 20);

create table subquery775798 as SELECT AVG(ss_list_price) AS B1_LP, COUNT(ss_list_price) AS B1_CNT, COUNT(DISTINCT ss_list_price) AS B1_CNTD FROM store_sales WHERE ss_quantity BETWEEN 0 AND 5 AND (ss_list_price BETWEEN 4 AND 4 + 10 OR ss_coupon_amt BETWEEN 715 AND 715 + 1000 OR ss_wholesale_cost BETWEEN 57 AND 57 + 20);

create table subquery576232 as SELECT * FROM (select * from subquery775798) AS B1, (select * from subquery469772) AS B2, (select * from subquery52789) AS B3, (select * from subquery618386) AS B4, (select * from subquery539650) AS B5, (select * from subquery38335) AS B6;

SELECT * FROM (select * from subquery576232) WHERE rownum <= 100;

