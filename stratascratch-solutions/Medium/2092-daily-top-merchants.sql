WITH ranked_orders as (
    SELECT   merchant_id,
             order_timestamp::date as order_day,
             DENSE_RANK() OVER(PARTITION BY order_timestamp::date ORDER BY COUNT(customer_id) desc) as rn
    FROM     order_details
    GROUP BY 1, 2
)
SELECT order_day,
       name,
       rn
FROM   ranked_orders ro JOIN merchant_details md ON ro.merchant_id=md.id
WHERE  rn <= 3



-- NOTE: solved in first attempt