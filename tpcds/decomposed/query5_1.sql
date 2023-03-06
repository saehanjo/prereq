create table subquery796424 as SELECT sr_store_sk AS store_sk, sr_returned_date_sk AS date_sk, CAST(0 AS DECIMAL(7, 2)) AS sales_price, CAST(0 AS DECIMAL(7, 2)) AS profit, sr_return_amt AS return_amt, sr_net_loss AS net_loss FROM store_returns;

create table subquery207438 as SELECT ss_store_sk AS store_sk, ss_sold_date_sk AS date_sk, ss_ext_sales_price AS sales_price, ss_net_profit AS profit, CAST(0 AS DECIMAL(7, 2)) AS return_amt, CAST(0 AS DECIMAL(7, 2)) AS net_loss FROM store_sales;

create table subquery1288 as SELECT s_store_id, SUM(sales_price) AS sales, SUM(profit) AS profit, SUM(return_amt) AS returns, SUM(net_loss) AS profit_loss FROM (select * from subquery207438 UNION ALL select * from subquery796424) AS salesreturns, date_dim, store WHERE date_sk = d_date_sk AND d_date BETWEEN CAST('2002-08-27' AS DATE) AND (CAST('2002-08-27' AS DATE) + 14) AND store_sk = s_store_sk GROUP BY s_store_id;

create table subquery381075 as SELECT cr_catalog_page_sk AS page_sk, cr_returned_date_sk AS date_sk, CAST(0 AS DECIMAL(7, 2)) AS sales_price, CAST(0 AS DECIMAL(7, 2)) AS profit, cr_return_amount AS return_amt, cr_net_loss AS net_loss FROM catalog_returns;

create table subquery536614 as SELECT cs_catalog_page_sk AS page_sk, cs_sold_date_sk AS date_sk, cs_ext_sales_price AS sales_price, cs_net_profit AS profit, CAST(0 AS DECIMAL(7, 2)) AS return_amt, CAST(0 AS DECIMAL(7, 2)) AS net_loss FROM catalog_sales;

create table subquery552081 as SELECT cp_catalog_page_id, SUM(sales_price) AS sales, SUM(profit) AS profit, SUM(return_amt) AS returns, SUM(net_loss) AS profit_loss FROM (select * from subquery536614 UNION ALL select * from subquery381075) AS salesreturns, date_dim, catalog_page WHERE date_sk = d_date_sk AND d_date BETWEEN CAST('2002-08-27' AS DATE) AND (CAST('2002-08-27' AS DATE) + 14) AND page_sk = cp_catalog_page_sk GROUP BY cp_catalog_page_id;

create table subquery790847 as SELECT ws_web_site_sk AS wsr_web_site_sk, wr_returned_date_sk AS date_sk, CAST(0 AS DECIMAL(7, 2)) AS sales_price, CAST(0 AS DECIMAL(7, 2)) AS profit, wr_return_amt AS return_amt, wr_net_loss AS net_loss FROM web_returns LEFT OUTER JOIN web_sales ON (wr_item_sk = ws_item_sk AND wr_order_number = ws_order_number);

create table subquery369409 as SELECT ws_web_site_sk AS wsr_web_site_sk, ws_sold_date_sk AS date_sk, ws_ext_sales_price AS sales_price, ws_net_profit AS profit, CAST(0 AS DECIMAL(7, 2)) AS return_amt, CAST(0 AS DECIMAL(7, 2)) AS net_loss FROM web_sales;

create table subquery185852 as SELECT web_site_id, SUM(sales_price) AS sales, SUM(profit) AS profit, SUM(return_amt) AS returns, SUM(net_loss) AS profit_loss FROM (select * from subquery369409 UNION ALL select * from subquery790847) AS salesreturns, date_dim, web_site WHERE date_sk = d_date_sk AND d_date BETWEEN CAST('2002-08-27' AS DATE) AND (CAST('2002-08-27' AS DATE) + 14) AND wsr_web_site_sk = web_site_sk GROUP BY web_site_id;

create table subquery228376 as with wsr AS (select * from subquery185852) SELECT 'web channel' AS channel, 'web_site' || web_site_id AS id, sales, returns, (profit - profit_loss) AS profit FROM wsr;

create table subquery383703 as with csr AS (select * from subquery552081) SELECT 'catalog channel' AS channel, 'catalog_page' || cp_catalog_page_id AS id, sales, returns, (profit - profit_loss) AS profit FROM csr;

create table subquery425789 as with ssr AS (select * from subquery1288) SELECT 'store channel' AS channel, 'store' || s_store_id AS id, sales, returns, (profit - profit_loss) AS profit FROM ssr;

create table subquery573769 as with ssr AS (select * from subquery1288), csr AS (select * from subquery552081), wsr AS (select * from subquery185852) SELECT channel, id, SUM(sales) AS sales, SUM(returns) AS returns, SUM(profit) AS profit FROM (select * from subquery425789 UNION ALL select * from subquery383703 UNION ALL select * from subquery228376) AS x GROUP BY ROLLUP(channel, id) ORDER BY channel, id;

WITH ssr AS (select * from subquery1288), csr AS (select * from subquery552081), wsr AS (select * from subquery185852) SELECT * FROM (select * from subquery573769) WHERE rownum <= 100;

