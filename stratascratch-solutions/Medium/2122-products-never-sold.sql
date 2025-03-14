WITH CTE as (
    SELECT   opc.category_id, 
             COALESCE(SUM(oo.units_sold), 0) as tot_units_sold
    FROM     online_product_categories opc LEFT JOIN online_products op ON opc.category_id = op.product_category
                                           LEFT JOIN online_orders oo ON op.product_id = oo.product_id
    GROUP BY opc.category_id
)
SELECT 100.0 * SUM(CASE WHEN tot_units_sold = 0 THEN 1 ELSE 0 END) / COUNT(category_id) as percentage_of_unsold_categories
FROM   CTE

