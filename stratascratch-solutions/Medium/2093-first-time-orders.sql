WITH get_first_merchant as (
    SELECT customer_id,
           FIRST_VALUE(merchant_id) OVER(PARTITION BY customer_id ORDER BY order_timestamp) as first_merchant
    FROM   order_details
),
get_order_counts as (
    SELECT   merchant_id, 
             COUNT(distinct id) as total_number_of_orders,
             COUNT(distinct fm.customer_id) as first_time_orders
    FROM     order_details od LEFT JOIN get_first_merchant fm ON od.merchant_id=fm.first_merchant
    GROUP BY 1
)
SELECT md.name,
       oc.total_number_of_orders,
       oc.first_time_orders
FROM   get_order_counts oc JOIN merchant_details md ON oc.merchant_id=md.id




-- NOTE: couldn't think on own to use FIRST_VALUE() window function.