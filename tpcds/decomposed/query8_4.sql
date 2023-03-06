create table subquery633779 as SELECT SUBSTR(ca_zip, 1, 5) AS ca_zip, COUNT(*) AS cnt FROM customer_address, customer WHERE ca_address_sk = c_current_addr_sk AND c_preferred_cust_flag = 'Y' GROUP BY ca_zip HAVING COUNT(*) > 10;

create table subquery762315 as SELECT ca_zip FROM (select * from subquery633779) AS A1;

create table subquery910142 as SELECT SUBSTR(ca_zip, 1, 5) AS ca_zip FROM customer_address WHERE SUBSTR(ca_zip, 1, 5) IN ('45668', '76354', '81597', '53104', '83327', '71160', '16202', '72223', '56234', '78657', '62685', '69606', '26439', '71477', '36328', '59828', '60747', '97403', '18089', '10060', '22229', '46524', '54122', '48813', '84953', '34065', '83235', '21581', '24789', '35540', '47232', '95128', '49367', '72120', '22527', '87230', '63912', '69026', '94732', '18600', '94342', '86252', '79429', '52063', '12278', '44614', '42875', '38122', '75434', '85324', '75239', '32596', '58739', '44672', '52422', '47133', '72160', '67458', '71216', '77817', '37400', '46836', '44714', '95832', '48742', '80894', '21593', '26628', '35530', '16213', '90639', '72890', '60966', '82176', '31195', '20644', '16818', '56199', '44420', '89733', '36142', '88658', '13794', '68216', '92203', '89084', '40553', '35279', '45836', '50678', '30458', '51896', '72476', '98846', '61789', '87923', '77755', '16152', '71184', '94257', '87164', '13774', '83775', '36352', '42068', '20106', '13766', '33769', '62433', '11994', '16833', '29646', '23316', '47495', '75237', '17765', '80186', '55631', '71371', '77480', '26879', '88764', '40883', '16847', '60846', '65570', '40263', '95647', '17247', '71687', '49110', '11299', '87844', '17405', '44373', '83599', '41727', '30891', '25629', '32225', '46017', '70007', '20812', '76949', '69473', '69888', '88556', '55245', '33791', '97766', '35872', '38336', '15901', '50031', '26021', '28130', '71157', '36404', '62044', '25524', '39381', '78301', '93617', '37026', '60697', '87925', '20408', '47249', '47015', '59028', '14803', '96494', '12747', '92584', '47590', '66688', '90660', '73711', '90553', '47488', '16689', '79739', '89687', '70059', '16775', '13540', '90235', '29588', '39064', '49413', '67524', '97081', '14332', '12561', '53899', '94597', '82561', '11509', '53682', '58279', '28351', '52791', '54523', '31116', '41035', '67140', '99472', '14454', '40534', '95853', '80706', '43319', '98753', '70022', '54577', '62914', '37987', '73937', '71055', '21351', '39302', '35383', '86807', '55276', '81377', '83005', '89224', '44073', '67934', '68147', '68120', '87952', '11188', '39288', '65655', '37017', '80219', '38816', '55657', '78780', '53793', '25337', '86978', '52138', '64549', '11745', '26203', '33437', '54498', '52089', '28554', '10139', '30116', '60112', '22119', '68437', '27812', '19541', '44598', '65764', '81782', '97369', '37669', '29071', '28327', '49968', '64748', '64601', '38658', '33337', '15888', '44219', '89633', '69645', '75929', '67683', '46653', '60187', '41112', '41887', '67960', '94164', '30876', '50638', '88490', '20677', '53769', '85942', '25570', '41331', '44043', '93211', '26809', '52764', '38725', '23154', '19487', '26499', '48162', '34854', '95801', '30866', '58446', '83233', '48425', '37971', '65846', '95370', '57300', '61177');

create table subquery673669 as SELECT ca_zip FROM (select * from subquery910142 INTERSECT select * from subquery762315) AS A2;

create table subquery840343 as SELECT s_store_name, SUM(ss_net_profit) FROM store_sales, date_dim, store, (select * from subquery673669) AS V1 WHERE ss_store_sk = s_store_sk AND ss_sold_date_sk = d_date_sk AND d_qoy = 2 AND d_year = 1999 AND (SUBSTR(s_zip, 1, 2) = SUBSTR(V1.ca_zip, 1, 2)) GROUP BY s_store_name ORDER BY s_store_name;

SELECT * FROM (select * from subquery840343) WHERE rownum <= 100;

