WITH ranked_orders as (
    SELECT   promotion_id,
             product_id,
             SUM(units_sold) as total_sales,
             RANK() OVER(PARTITION BY promotion_id ORDER BY SUM(units_sold) desc) as rn
    FROM     online_orders
    GROUP BY 1, 2
)
SELECT promotion_id, product_id, total_sales
FROM   ranked_orders
WHERE  rn=1



-- NOTE: solved on first attempt