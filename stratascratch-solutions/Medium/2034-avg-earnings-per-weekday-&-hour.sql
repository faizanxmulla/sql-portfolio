SELECT   TO_CHAR(customer_placed_order_datetime, 'Day') as weekday, 
         EXTRACT(HOUR FROM customer_placed_order_datetime) as hour,
         AVG(order_total + tip_amount - refunded_amount - discount_amount) as avg_net_order_total
FROM     doordash_delivery
GROUP BY 1, 2



-- NOTE: solved in first attempt