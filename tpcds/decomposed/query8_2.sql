create table subquery707327 as SELECT SUBSTR(ca_zip, 1, 5) AS ca_zip, COUNT(*) AS cnt FROM customer_address, customer WHERE ca_address_sk = c_current_addr_sk AND c_preferred_cust_flag = 'Y' GROUP BY ca_zip HAVING COUNT(*) > 10;

create table subquery72300 as SELECT ca_zip FROM (select * from subquery707327) AS A1;

create table subquery935563 as SELECT SUBSTR(ca_zip, 1, 5) AS ca_zip FROM customer_address WHERE SUBSTR(ca_zip, 1, 5) IN ('99472', '64189', '49539', '33974', '84461', '37743', '17714', '70007', '91086', '94817', '60800', '48495', '48162', '52882', '10854', '27904', '13267', '40528', '64542', '14982', '30202', '33519', '45675', '90639', '29146', '33616', '56228', '10942', '87177', '24131', '56641', '44509', '10920', '32307', '72941', '18577', '38877', '87314', '60774', '16515', '79160', '91349', '39381', '17005', '20076', '44480', '18726', '26909', '13850', '17206', '24784', '32999', '20279', '53812', '58317', '46320', '12685', '99617', '12886', '43103', '23340', '87142', '64860', '82963', '36561', '68717', '21657', '31172', '54212', '48509', '57146', '94348', '30635', '61892', '97963', '87230', '54267', '50862', '48597', '15889', '81535', '82275', '57008', '76724', '48513', '32772', '91759', '88320', '11926', '31664', '85021', '98180', '53452', '68794', '16316', '50330', '64913', '62372', '25738', '10709', '16115', '38550', '29867', '57130', '86776', '34678', '63368', '98974', '14211', '52895', '38033', '32195', '13573', '52581', '31614', '16603', '97824', '72791', '75086', '71389', '28171', '64098', '35194', '29122', '68571', '34024', '40155', '37313', '87995', '16288', '84693', '65240', '50568', '51040', '79708', '20292', '48191', '74569', '81337', '59028', '56584', '18535', '46898', '62118', '10897', '88090', '63839', '67643', '52804', '32487', '43091', '62006', '85447', '14744', '71653');

create table subquery987892 as SELECT ca_zip FROM (select * from subquery935563 INTERSECT select * from subquery72300) AS A2;

create table subquery647260 as SELECT s_store_name, SUM(ss_net_profit) FROM store_sales, date_dim, store, (select * from subquery987892) AS V1 WHERE ss_store_sk = s_store_sk AND ss_sold_date_sk = d_date_sk AND d_qoy = 1 AND d_year = 2001 AND (SUBSTR(s_zip, 1, 2) = SUBSTR(V1.ca_zip, 1, 2)) GROUP BY s_store_name ORDER BY s_store_name;

SELECT * FROM (select * from subquery647260) WHERE rownum <= 100;

