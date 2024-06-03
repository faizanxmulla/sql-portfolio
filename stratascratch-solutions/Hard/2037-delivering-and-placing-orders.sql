SELECT   restaurant_id, 
         AVG(order_total - discount_amount - refunded_amount + tip_amount) AS avg_tov,
         AVG(EXTRACT(EPOCH FROM delivered_to_consumer_datetime - placed_order_with_restaurant_datetime) / 60) as avg_time_for_delivery
FROM     delivery_details
WHERE    delivered_to_consumer_datetime IS NOT NULL AND 
         placed_order_with_restaurant_datetime IS NOT NULL
GROUP BY 1