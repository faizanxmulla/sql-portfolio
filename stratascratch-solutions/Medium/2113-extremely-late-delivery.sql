SELECT   TO_CHAR(order_placed_time, 'YYYY-MM') as year_month,
         100.0 * COUNT(delivery_id) FILTER(WHERE actual_delivery_time - predicted_delivery_time > INTERVAL '20 minutes') /
                 COUNT(delivery_id) as perc_extremely_delayed
FROM     delivery_orders
WHERE    actual_delivery_time IS NOT NULL
GROUP BY 1



-- NOTE: made a small mistake in the year month column, chose "actual_delivery_time" instead of "order_placed_time".