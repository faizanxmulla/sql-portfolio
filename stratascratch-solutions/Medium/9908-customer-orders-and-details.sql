SELECT   city, 
         COUNT(distinct o.id) as orders_per_city,
         COUNT(distinct c.id) as customers_per_city,
         SUM(o.total_order_cost) as orders_cost_per_city
FROM     customers c LEFT JOIN orders o ON c.id=o.cust_id
GROUP BY city
HAVING   COUNT(o.id) >= 5