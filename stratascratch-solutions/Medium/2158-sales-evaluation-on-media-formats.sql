WITH get_total_sales as (
    SELECT   p.product_family,
             sp.media_type,
             SUM(units_sold * cost_in_dollars) as total_sales
    FROM     online_products p JOIN online_orders o ON p.product_id=o.product_id
                               JOIN online_sales_promotions sp ON sp.promotion_id=o.promotion_id
    GROUP BY 1, 2
)
,get_family_sales as (
    SELECT   product_family, SUM(total_sales) as sales_per_family
    FROM     get_total_sales
    GROUP BY product_family
)
SELECT ts.product_family, 
       media_type,
       ROUND(100.0 * (total_sales / sales_per_family)) as pc_sales
FROM   get_total_sales ts JOIN get_family_sales fs ON ts.product_family=fs.product_family



-- NOTE: earlier was trying to solve without CTE.