SELECT COUNT(distinct c.id) as n_customers_without_orders
FROM   customers c LEFT JOIN orders o ON o.cust_id = c.id
WHERE  o.cust_id IS NULL