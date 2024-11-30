WITH CTE as (
    SELECT driver_id
    FROM   delivery_details
    WHERE  delivered_to_consumer_datetime - customer_placed_order_datetime <= INTERVAL '45 minutes'
)
SELECT   c.driver_id, AVG(order_total) as avg_total
FROM     delivery_details dd JOIN CTE c ON dd.driver_id=c.driver_id
GROUP BY c.driver_id



-- NOTE: solved on second attempt; initially was just implementing witout cte