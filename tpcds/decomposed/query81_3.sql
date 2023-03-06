create table subquery449889 as SELECT s_store_sk, SUM(ss_ext_sales_price) AS sales, SUM(ss_net_profit) AS profit FROM store_sales, date_dim, store WHERE ss_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('2001-08-23' AS DATE) AND (CAST('2001-08-23' AS DATE) + 30) AND ss_store_sk = s_store_sk GROUP BY s_store_sk;

create table subquery444100 as SELECT s_store_sk, SUM(sr_return_amt) AS returns, SUM(sr_net_loss) AS profit_loss FROM store_returns, date_dim, store WHERE sr_returned_date_sk = d_date_sk AND d_date BETWEEN CAST('2001-08-23' AS DATE) AND (CAST('2001-08-23' AS DATE) + 30) AND sr_store_sk = s_store_sk GROUP BY s_store_sk;

create table subquery669441 as SELECT cs_call_center_sk, SUM(cs_ext_sales_price) AS sales, SUM(cs_net_profit) AS profit FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('2001-08-23' AS DATE) AND (CAST('2001-08-23' AS DATE) + 30) GROUP BY cs_call_center_sk;

create table subquery458765 as SELECT cr_call_center_sk, SUM(cr_return_amount) AS returns, SUM(cr_net_loss) AS profit_loss FROM catalog_returns, date_dim WHERE cr_returned_date_sk = d_date_sk AND d_date BETWEEN CAST('2001-08-23' AS DATE) AND (CAST('2001-08-23' AS DATE) + 30) GROUP BY cr_call_center_sk;

create table subquery322673 as SELECT wp_web_page_sk, SUM(ws_ext_sales_price) AS sales, SUM(ws_net_profit) AS profit FROM web_sales, date_dim, web_page WHERE ws_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('2001-08-23' AS DATE) AND (CAST('2001-08-23' AS DATE) + 30) AND ws_web_page_sk = wp_web_page_sk GROUP BY wp_web_page_sk;

create table subquery258038 as SELECT wp_web_page_sk, SUM(wr_return_amt) AS returns, SUM(wr_net_loss) AS profit_loss FROM web_returns, date_dim, web_page WHERE wr_returned_date_sk = d_date_sk AND d_date BETWEEN CAST('2001-08-23' AS DATE) AND (CAST('2001-08-23' AS DATE) + 30) AND wr_web_page_sk = wp_web_page_sk GROUP BY wp_web_page_sk;

create table subquery413017 as with ws AS (select * from subquery322673), wr AS (select * from subquery258038) SELECT 'web channel' AS channel, ws.wp_web_page_sk AS id, sales, COALESCE(returns, 0) AS returns, (profit - COALESCE(profit_loss, 0)) AS profit FROM ws LEFT JOIN wr ON ws.wp_web_page_sk = wr.wp_web_page_sk;

create table subquery178422 as with cs AS (select * from subquery669441), cr AS (select * from subquery458765) SELECT 'catalog channel' AS channel, cs_call_center_sk AS id, sales, returns, (profit - profit_loss) AS profit FROM cs, cr;

create table subquery363517 as with ss AS (select * from subquery449889), sr AS (select * from subquery444100) SELECT 'store channel' AS channel, ss.s_store_sk AS id, sales, COALESCE(returns, 0) AS returns, (profit - COALESCE(profit_loss, 0)) AS profit FROM ss LEFT JOIN sr ON ss.s_store_sk = sr.s_store_sk;

create table subquery568921 as with ss AS (select * from subquery449889), sr AS (select * from subquery444100), cs AS (select * from subquery669441), cr AS (select * from subquery458765), ws AS (select * from subquery322673), wr AS (select * from subquery258038) SELECT channel, id, SUM(sales) AS sales, SUM(returns) AS returns, SUM(profit) AS profit FROM (select * from subquery363517 UNION ALL select * from subquery178422 UNION ALL select * from subquery413017) AS x GROUP BY ROLLUP(channel, id) ORDER BY channel, id;

WITH ss AS (select * from subquery449889), sr AS (select * from subquery444100), cs AS (select * from subquery669441), cr AS (select * from subquery458765), ws AS (select * from subquery322673), wr AS (select * from subquery258038) SELECT * FROM (select * from subquery568921) WHERE rownum <= 100;

