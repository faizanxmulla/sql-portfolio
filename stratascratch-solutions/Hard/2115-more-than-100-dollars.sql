WITH CTE AS (
    SELECT   EXTRACT(MONTH FROM order_placed_time) AS month,
             restaurant_id, 
             SUM(sales_amount) AS monthly_sales
    FROM     delivery_orders d JOIN order_value ov USING(delivery_id)
    WHERE    EXTRACT(YEAR FROM order_placed_time) = '2021' AND 
             actual_delivery_time IS NOT NULL
    GROUP BY 1, 2
    HAVING   SUM(sales_amount) >= 100
    ORDER BY 1, 2
)
SELECT   month, 
         100.0 * COUNT(c.restaurant_id) / 
                (SELECT COUNT(DISTINCT restaurant_id) 
                 FROM   delivery_orders) AS percentage
FROM     CTE c
GROUP BY 1
ORDER BY 1