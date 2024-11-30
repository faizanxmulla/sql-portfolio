WITH ranked_order_counts as (
    SELECT   TO_CHAR(timestamp, 'Day') as day_of_week,
             CASE 
                  WHEN EXTRACT(HOUR FROM timestamp) < 12 THEN 'Morning'
                  WHEN EXTRACT(HOUR FROM timestamp) > 15 THEN 'Late afternoon'
                  ELSE 'Early afternoon'
              END as time_of_day,
              COUNT(order_id) as total_orders,
              DENSE_RANK() OVER(ORDER BY COUNT(order_id) desc) as rn
    FROM     sales_log
    GROUP BY 1, 2
)
SELECT day_of_week, time_of_day, total_orders
FROM   ranked_order_counts
WHERE  rn <= 2




-- NOTE: solved on first attempt