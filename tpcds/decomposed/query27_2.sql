create table subquery356428 as SELECT c_last_name, c_first_name, s_store_name, ca_state, s_state, i_color, i_current_price, i_manager_id, i_units, i_size, SUM(ss_net_paid) AS netpaid FROM store_sales, store_returns, store, item, customer, customer_address WHERE ss_ticket_number = sr_ticket_number AND ss_item_sk = sr_item_sk AND ss_customer_sk = c_customer_sk AND ss_item_sk = i_item_sk AND ss_store_sk = s_store_sk AND c_current_addr_sk = ca_address_sk AND c_birth_country <> UPPER(ca_country) AND s_zip = ca_zip AND s_market_id = 7 GROUP BY c_last_name, c_first_name, s_store_name, ca_state, s_state, i_color, i_current_price, i_manager_id, i_units, i_size;

create table subquery652742 as with ssales AS (select * from subquery356428) SELECT 0.05 * AVG(netpaid) FROM ssales;

WITH ssales AS (select * from subquery356428) SELECT c_last_name, c_first_name, s_store_name, SUM(netpaid) AS paid FROM ssales WHERE i_color = 'khaki' GROUP BY c_last_name, c_first_name, s_store_name HAVING SUM(netpaid) > (select * from subquery652742) ORDER BY c_last_name, c_first_name, s_store_name;

