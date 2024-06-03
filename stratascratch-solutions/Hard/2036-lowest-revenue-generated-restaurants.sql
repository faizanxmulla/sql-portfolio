WITH percentile_cte AS (
    SELECT  restaurant_id, 
            SUM(order_total) AS total_revenue, 
            CUME_DIST() OVER(ORDER BY SUM(order_total)) AS percentile
    FROM    doordash_delivery
    WHERE   TO_CHAR(customer_placed_order_datetime, 'YYYY-MM') = '2020-05'
    GROUP BY 1
    ORDER BY 2
)
SELECT restaurant_id, total_revenue
FROM   percentile_cte
WHERE  percentile <= 0.02