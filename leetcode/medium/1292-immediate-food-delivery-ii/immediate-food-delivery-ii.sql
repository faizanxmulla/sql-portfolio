SELECT ROUND(AVG(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
FROM Delivery 
WHERE (customer_id, order_date) IN 
    (
        SELECT customer_id, MIN(order_date) 
        FROM Delivery
        GROUP BY 1
    )
