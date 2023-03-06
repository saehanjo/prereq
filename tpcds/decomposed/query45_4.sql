create table subquery40543 as SELECT DISTINCT (i_product_name) FROM item AS i1 WHERE i_manufact_id BETWEEN 885 AND 885 + 40 AND (SELECT COUNT(*) AS item_cnt FROM item WHERE (i_manufact = i1.i_manufact AND ((i_category = 'Women' AND (i_color = 'chartreuse' OR i_color = 'dark') AND (i_units = 'Lb' OR i_units = 'Case') AND (i_size = 'extra large' OR i_size = 'large')) OR (i_category = 'Women' AND (i_color = 'azure' OR i_color = 'seashell') AND (i_units = 'Cup' OR i_units = 'Ton') AND (i_size = 'medium' OR i_size = 'economy')) OR (i_category = 'Men' AND (i_color = 'yellow' OR i_color = 'midnight') AND (i_units = 'Oz' OR i_units = 'Pallet') AND (i_size = 'petite' OR i_size = 'small')) OR (i_category = 'Men' AND (i_color = 'blush' OR i_color = 'blue') AND (i_units = 'Bundle' OR i_units = 'Gram') AND (i_size = 'extra large' OR i_size = 'large')))) OR (i_manufact = i1.i_manufact AND ((i_category = 'Women' AND (i_color = 'sky' OR i_color = 'burlywood') AND (i_units = 'Unknown' OR i_units = 'Tbl') AND (i_size = 'extra large' OR i_size = 'large')) OR (i_category = 'Women' AND (i_color = 'dim' OR i_color = 'peach') AND (i_units = 'Gross' OR i_units = 'Tsp') AND (i_size = 'medium' OR i_size = 'economy')) OR (i_category = 'Men' AND (i_color = 'ghost' OR i_color = 'dodger') AND (i_units = 'Pound' OR i_units = 'Dozen') AND (i_size = 'petite' OR i_size = 'small')) OR (i_category = 'Men' AND (i_color = 'cream' OR i_color = 'puff') AND (i_units = 'N/A' OR i_units = 'Bunch') AND (i_size = 'extra large' OR i_size = 'large'))))) > 0 ORDER BY i_product_name;

SELECT * FROM (select * from subquery40543) WHERE rownum <= 100;
