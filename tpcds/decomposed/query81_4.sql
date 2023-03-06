create table subquery149457 as SELECT s_store_sk, SUM(ss_ext_sales_price) AS sales, SUM(ss_net_profit) AS profit FROM store_sales, date_dim, store WHERE ss_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-13' AS DATE) AND (CAST('1999-08-13' AS DATE) + 30) AND ss_store_sk = s_store_sk GROUP BY s_store_sk;

create table subquery29524 as SELECT s_store_sk, SUM(sr_return_amt) AS returns, SUM(sr_net_loss) AS profit_loss FROM store_returns, date_dim, store WHERE sr_returned_date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-13' AS DATE) AND (CAST('1999-08-13' AS DATE) + 30) AND sr_store_sk = s_store_sk GROUP BY s_store_sk;

create table subquery83668 as SELECT cs_call_center_sk, SUM(cs_ext_sales_price) AS sales, SUM(cs_net_profit) AS profit FROM catalog_sales, date_dim WHERE cs_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-13' AS DATE) AND (CAST('1999-08-13' AS DATE) + 30) GROUP BY cs_call_center_sk;

create table subquery183429 as SELECT cr_call_center_sk, SUM(cr_return_amount) AS returns, SUM(cr_net_loss) AS profit_loss FROM catalog_returns, date_dim WHERE cr_returned_date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-13' AS DATE) AND (CAST('1999-08-13' AS DATE) + 30) GROUP BY cr_call_center_sk;

create table subquery859580 as SELECT wp_web_page_sk, SUM(ws_ext_sales_price) AS sales, SUM(ws_net_profit) AS profit FROM web_sales, date_dim, web_page WHERE ws_sold_date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-13' AS DATE) AND (CAST('1999-08-13' AS DATE) + 30) AND ws_web_page_sk = wp_web_page_sk GROUP BY wp_web_page_sk;

create table subquery243801 as SELECT wp_web_page_sk, SUM(wr_return_amt) AS returns, SUM(wr_net_loss) AS profit_loss FROM web_returns, date_dim, web_page WHERE wr_returned_date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-13' AS DATE) AND (CAST('1999-08-13' AS DATE) + 30) AND wr_web_page_sk = wp_web_page_sk GROUP BY wp_web_page_sk;

create table subquery489997 as with ws AS (select * from subquery859580), wr AS (select * from subquery243801) SELECT 'web channel' AS channel, ws.wp_web_page_sk AS id, sales, COALESCE(returns, 0) AS returns, (profit - COALESCE(profit_loss, 0)) AS profit FROM ws LEFT JOIN wr ON ws.wp_web_page_sk = wr.wp_web_page_sk;

create table subquery823425 as with cs AS (select * from subquery83668), cr AS (select * from subquery183429) SELECT 'catalog channel' AS channel, cs_call_center_sk AS id, sales, returns, (profit - profit_loss) AS profit FROM cs, cr;

create table subquery400233 as with ss AS (select * from subquery149457), sr AS (select * from subquery29524) SELECT 'store channel' AS channel, ss.s_store_sk AS id, sales, COALESCE(returns, 0) AS returns, (profit - COALESCE(profit_loss, 0)) AS profit FROM ss LEFT JOIN sr ON ss.s_store_sk = sr.s_store_sk;

create table subquery548635 as with ss AS (select * from subquery149457), sr AS (select * from subquery29524), cs AS (select * from subquery83668), cr AS (select * from subquery183429), ws AS (select * from subquery859580), wr AS (select * from subquery243801) SELECT channel, id, SUM(sales) AS sales, SUM(returns) AS returns, SUM(profit) AS profit FROM (select * from subquery400233 UNION ALL select * from subquery823425 UNION ALL select * from subquery489997) AS x GROUP BY ROLLUP(channel, id) ORDER BY channel, id;

WITH ss AS (select * from subquery149457), sr AS (select * from subquery29524), cs AS (select * from subquery83668), cr AS (select * from subquery183429), ws AS (select * from subquery859580), wr AS (select * from subquery243801) SELECT * FROM (select * from subquery548635) WHERE rownum <= 100;

