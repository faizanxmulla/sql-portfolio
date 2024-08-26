SELECT   EXTRACT(MONTH FROM created_at) as month
         ,COUNT(DISTINCT user_id) as num_customers
         ,COUNT(t.id) as num_orders
         ,SUM(quantity * price) as order_amt
FROM     users u JOIN transactions t ON u.id=t.user_id
                 JOIN products p ON p.id=t.product_id
GROUP BY 1
ORDER BY 1



-- NOTE: very straightforward question