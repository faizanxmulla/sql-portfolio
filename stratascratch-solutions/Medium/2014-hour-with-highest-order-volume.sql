WITH get_order_count as (
    SELECT   order_timestamp_utc::date,
             EXTRACT(HOUR FROM order_timestamp_utc) as hour,
             COUNT(id) as order_count
    FROM     postmates_orders
    GROUP BY 1, 2 
)
, get_avg_orders as (
    SELECT   hour, AVG(order_count) as avg_orders
    FROM     get_order_count
    GROUP BY 1
)
SELECT   hour, avg_orders
FROM     get_avg_orders
WHERE    avg_orders = (SELECT MAX(avg_orders) FROM get_avg_orders)
ORDER BY 2 desc



-- note: a bit deceiving in terms of difficulty. 