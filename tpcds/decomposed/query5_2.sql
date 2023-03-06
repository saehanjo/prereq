create table subquery935642 as SELECT sr_store_sk AS store_sk, sr_returned_date_sk AS date_sk, CAST(0 AS DECIMAL(7, 2)) AS sales_price, CAST(0 AS DECIMAL(7, 2)) AS profit, sr_return_amt AS return_amt, sr_net_loss AS net_loss FROM store_returns;

create table subquery788735 as SELECT ss_store_sk AS store_sk, ss_sold_date_sk AS date_sk, ss_ext_sales_price AS sales_price, ss_net_profit AS profit, CAST(0 AS DECIMAL(7, 2)) AS return_amt, CAST(0 AS DECIMAL(7, 2)) AS net_loss FROM store_sales;

create table subquery131205 as SELECT s_store_id, SUM(sales_price) AS sales, SUM(profit) AS profit, SUM(return_amt) AS returns, SUM(net_loss) AS profit_loss FROM (select * from subquery788735 UNION ALL select * from subquery935642) AS salesreturns, date_dim, store WHERE date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-25' AS DATE) AND (CAST('1999-08-25' AS DATE) + 14) AND store_sk = s_store_sk GROUP BY s_store_id;

create table subquery906289 as SELECT cr_catalog_page_sk AS page_sk, cr_returned_date_sk AS date_sk, CAST(0 AS DECIMAL(7, 2)) AS sales_price, CAST(0 AS DECIMAL(7, 2)) AS profit, cr_return_amount AS return_amt, cr_net_loss AS net_loss FROM catalog_returns;

create table subquery938010 as SELECT cs_catalog_page_sk AS page_sk, cs_sold_date_sk AS date_sk, cs_ext_sales_price AS sales_price, cs_net_profit AS profit, CAST(0 AS DECIMAL(7, 2)) AS return_amt, CAST(0 AS DECIMAL(7, 2)) AS net_loss FROM catalog_sales;

create table subquery40650 as SELECT cp_catalog_page_id, SUM(sales_price) AS sales, SUM(profit) AS profit, SUM(return_amt) AS returns, SUM(net_loss) AS profit_loss FROM (select * from subquery938010 UNION ALL select * from subquery906289) AS salesreturns, date_dim, catalog_page WHERE date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-25' AS DATE) AND (CAST('1999-08-25' AS DATE) + 14) AND page_sk = cp_catalog_page_sk GROUP BY cp_catalog_page_id;

create table subquery674046 as SELECT ws_web_site_sk AS wsr_web_site_sk, wr_returned_date_sk AS date_sk, CAST(0 AS DECIMAL(7, 2)) AS sales_price, CAST(0 AS DECIMAL(7, 2)) AS profit, wr_return_amt AS return_amt, wr_net_loss AS net_loss FROM web_returns LEFT OUTER JOIN web_sales ON (wr_item_sk = ws_item_sk AND wr_order_number = ws_order_number);

create table subquery231008 as SELECT ws_web_site_sk AS wsr_web_site_sk, ws_sold_date_sk AS date_sk, ws_ext_sales_price AS sales_price, ws_net_profit AS profit, CAST(0 AS DECIMAL(7, 2)) AS return_amt, CAST(0 AS DECIMAL(7, 2)) AS net_loss FROM web_sales;

create table subquery438272 as SELECT web_site_id, SUM(sales_price) AS sales, SUM(profit) AS profit, SUM(return_amt) AS returns, SUM(net_loss) AS profit_loss FROM (select * from subquery231008 UNION ALL select * from subquery674046) AS salesreturns, date_dim, web_site WHERE date_sk = d_date_sk AND d_date BETWEEN CAST('1999-08-25' AS DATE) AND (CAST('1999-08-25' AS DATE) + 14) AND wsr_web_site_sk = web_site_sk GROUP BY web_site_id;

create table subquery944934 as with wsr AS (select * from subquery438272) SELECT 'web channel' AS channel, 'web_site' || web_site_id AS id, sales, returns, (profit - profit_loss) AS profit FROM wsr;

create table subquery628060 as with csr AS (select * from subquery40650) SELECT 'catalog channel' AS channel, 'catalog_page' || cp_catalog_page_id AS id, sales, returns, (profit - profit_loss) AS profit FROM csr;

create table subquery292615 as with ssr AS (select * from subquery131205) SELECT 'store channel' AS channel, 'store' || s_store_id AS id, sales, returns, (profit - profit_loss) AS profit FROM ssr;

create table subquery646264 as with ssr AS (select * from subquery131205), csr AS (select * from subquery40650), wsr AS (select * from subquery438272) SELECT channel, id, SUM(sales) AS sales, SUM(returns) AS returns, SUM(profit) AS profit FROM (select * from subquery292615 UNION ALL select * from subquery628060 UNION ALL select * from subquery944934) AS x GROUP BY ROLLUP(channel, id) ORDER BY channel, id;

WITH ssr AS (select * from subquery131205), csr AS (select * from subquery40650), wsr AS (select * from subquery438272) SELECT * FROM (select * from subquery646264) WHERE rownum <= 100;

