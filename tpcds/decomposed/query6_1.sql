create table subquery915677 as SELECT DISTINCT (d_month_seq) FROM date_dim WHERE d_year = 2000 AND d_moy = 3;

create table subquery50449 as SELECT a.ca_state AS state, COUNT(*) AS cnt FROM customer_address AS a, customer AS c, store_sales AS s, date_dim AS d, item AS i WHERE a.ca_address_sk = c.c_current_addr_sk AND c.c_customer_sk = s.ss_customer_sk AND s.ss_sold_date_sk = d.d_date_sk AND s.ss_item_sk = i.i_item_sk AND d.d_month_seq = (select * from subquery915677) AND i.i_current_price > 1.2 * (SELECT AVG(j.i_current_price) FROM item AS j WHERE j.i_category = i.i_category) GROUP BY a.ca_state HAVING COUNT(*) >= 10 ORDER BY cnt, a.ca_state;

SELECT * FROM (select * from subquery50449) WHERE rownum <= 100;

