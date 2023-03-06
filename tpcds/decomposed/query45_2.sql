create table subquery652567 as SELECT DISTINCT (i_product_name) FROM item AS i1 WHERE i_manufact_id BETWEEN 776 AND 776 + 40 AND (SELECT COUNT(*) AS item_cnt FROM item WHERE (i_manufact = i1.i_manufact AND ((i_category = 'Women' AND (i_color = 'lime' OR i_color = 'mint') AND (i_units = 'Tbl' OR i_units = 'Cup') AND (i_size = 'petite' OR i_size = 'N/A')) OR (i_category = 'Women' AND (i_color = 'blanched' OR i_color = 'blue') AND (i_units = 'Gram' OR i_units = 'Each') AND (i_size = 'small' OR i_size = 'extra large')) OR (i_category = 'Men' AND (i_color = 'coral' OR i_color = 'orchid') AND (i_units = 'Carton' OR i_units = 'Pound') AND (i_size = 'large' OR i_size = 'economy')) OR (i_category = 'Men' AND (i_color = 'seashell' OR i_color = 'burlywood') AND (i_units = 'Gross' OR i_units = 'Tsp') AND (i_size = 'petite' OR i_size = 'N/A')))) OR (i_manufact = i1.i_manufact AND ((i_category = 'Women' AND (i_color = 'grey' OR i_color = 'olive') AND (i_units = 'Ounce' OR i_units = 'Dram') AND (i_size = 'petite' OR i_size = 'N/A')) OR (i_category = 'Women' AND (i_color = 'firebrick' OR i_color = 'smoke') AND (i_units = 'N/A' OR i_units = 'Ton') AND (i_size = 'small' OR i_size = 'extra large')) OR (i_category = 'Men' AND (i_color = 'forest' OR i_color = 'lemon') AND (i_units = 'Unknown' OR i_units = 'Dozen') AND (i_size = 'large' OR i_size = 'economy')) OR (i_category = 'Men' AND (i_color = 'spring' OR i_color = 'deep') AND (i_units = 'Pallet' OR i_units = 'Case') AND (i_size = 'petite' OR i_size = 'N/A'))))) > 0 ORDER BY i_product_name;

SELECT * FROM (select * from subquery652567) WHERE rownum <= 100;
