WITH ranked_restaurants as (
    SELECT   restaurant_id,
             SUM(sales_amount) as total_sales,
             RANK() OVER(ORDER BY SUM(sales_amount) desc) as rn
    FROM     delivery_orders dd JOIN order_value ov ON dd.delivery_id = ov.delivery_id
    WHERE    actual_delivery_time IS NOT NULL
             and actual_delivery_time BETWEEN '2022-01-01' and '2022-12-31'
    GROUP BY restaurant_id
)
SELECT restaurant_id, total_sales
FROM   ranked_restaurants
WHERE  rn <= 2