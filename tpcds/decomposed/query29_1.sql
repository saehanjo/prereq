create table subquery37644 as SELECT i_item_id, AVG(cs_quantity) AS agg1, AVG(cs_list_price) AS agg2, AVG(cs_coupon_amt) AS agg3, AVG(cs_sales_price) AS agg4 FROM catalog_sales, customer_demographics, date_dim, item, promotion WHERE cs_sold_date_sk = d_date_sk AND cs_item_sk = i_item_sk AND cs_bill_cdemo_sk = cd_demo_sk AND cs_promo_sk = p_promo_sk AND cd_gender = 'F' AND cd_marital_status = 'M' AND cd_education_status = '4 yr Degree' AND (p_channel_email = 'N' OR p_channel_event = 'N') AND d_year = 2002 GROUP BY i_item_id ORDER BY i_item_id;

SELECT * FROM (select * from subquery37644) WHERE rownum <= 100;

