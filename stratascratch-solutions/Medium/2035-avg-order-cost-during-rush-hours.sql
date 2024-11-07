SELECT   EXTRACT(HOUR FROM customer_placed_order_datetime) as order_hour,
         AVG(order_total + tip_amount - refunded_amount - discount_amount) as avg_earnings
FROM     doordash_delivery
WHERE    delivery_region='San Jose' 
         and EXTRACT(HOUR FROM customer_placed_order_datetime) BETWEEN 15 AND 17
GROUP BY 1



-- NOTE: solved in first attempt