-- Solution 1: using CUME_DIST()

WITH percentile_cte AS (
    SELECT   restaurant_id, 
             SUM(order_total) AS total_revenue, 
             CUME_DIST() OVER(ORDER BY SUM(order_total)) AS percentile
    FROM     doordash_delivery
    WHERE    customer_placed_order_datetime BETWEEN '2020-05-01' and '2020-05-31'
    GROUP BY 1
    ORDER BY 2
)
SELECT restaurant_id, total_revenue
FROM   percentile_cte
WHERE  percentile <= 0.02



-- Solution 2: using NTILE()

WITH percentile_cte as (
    SELECT   restaurant_id, 
             SUM(order_total) as total_orders, 
             NTILE(50) OVER(ORDER BY SUM(order_total)) as ntile
    FROM     doordash_delivery
    WHERE    customer_placed_order_datetime BETWEEN '2020-05-01' and '2020-05-31'
    GROUP BY restaurant_id
)
SELECT   restaurant_id, total_orders 
FROM     percentile_cte 
WHERE    ntile=1
ORDER BY 2 DESC