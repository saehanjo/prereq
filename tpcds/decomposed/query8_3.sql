create table subquery629358 as SELECT SUBSTR(ca_zip, 1, 5) AS ca_zip, COUNT(*) AS cnt FROM customer_address, customer WHERE ca_address_sk = c_current_addr_sk AND c_preferred_cust_flag = 'Y' GROUP BY ca_zip HAVING COUNT(*) > 10;

create table subquery372329 as SELECT ca_zip FROM (select * from subquery629358) AS A1;

create table subquery180666 as SELECT SUBSTR(ca_zip, 1, 5) AS ca_zip FROM customer_address WHERE SUBSTR(ca_zip, 1, 5) IN ('67352', '14161', '52076', '40355', '86186', '30361', '70270', '11264', '12088', '90672', '55196', '21118', '72523', '20573', '56337', '74712', '13492', '19896', '90087', '17263', '47310', '77089', '34945', '67157', '62238', '99472', '95563', '12210', '35825', '14999', '26421', '34843', '75448', '23865', '74869', '50055', '85656', '12538', '17165', '20987', '96485', '75610', '18612', '72747', '67802', '24800', '33520', '13019', '13100', '19954', '48576', '43931', '29243', '40726', '94131', '71943', '38054', '14176', '20003', '20530', '25813', '16028', '57571', '21181', '16598', '30333', '79340', '63847', '74218', '65601', '44564', '80705', '18682', '68778', '64480', '20922', '32575', '30829', '31195', '72907', '27264', '87638', '93559', '34781', '26058', '16219', '93004', '29889', '31755', '66620', '65913', '67661', '84435', '79693', '32198', '23609', '31297', '82698', '47165', '63098', '23874', '82050', '51592', '53849', '71774', '64793', '26896', '86886', '92023', '39295', '50163', '12479', '86921', '31020', '41331', '87405', '21524', '78450', '25265', '20526', '80330', '31348', '37375', '32194', '71757', '67363', '13695', '17513', '75738', '75902', '42444', '44513', '37849', '10283', '59028', '83895', '14464', '22163', '53822', '39816', '12640', '57951', '93432', '36716', '13253', '24635', '93149', '71342', '11792', '25429', '38403', '15448', '73607', '50118', '41891', '37194');

create table subquery508910 as SELECT ca_zip FROM (select * from subquery180666 INTERSECT select * from subquery372329) AS A2;

create table subquery825309 as SELECT s_store_name, SUM(ss_net_profit) FROM store_sales, date_dim, store, (select * from subquery508910) AS V1 WHERE ss_store_sk = s_store_sk AND ss_sold_date_sk = d_date_sk AND d_qoy = 1 AND d_year = 1999 AND (SUBSTR(s_zip, 1, 2) = SUBSTR(V1.ca_zip, 1, 2)) GROUP BY s_store_name ORDER BY s_store_name;

SELECT * FROM (select * from subquery825309) WHERE rownum <= 100;

