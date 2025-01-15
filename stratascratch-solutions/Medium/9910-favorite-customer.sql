SELECT   c.first_name as name,
         c.city, 
         COUNT(distinct o.id) as orders_count,
         SUM(o.total_order_cost) as total_cost
FROM     customers c LEFT JOIN orders o ON c.id=o.cust_id
GROUP BY first_name, city
HAVING   COUNT(distinct o.id) > 3
         and SUM(o.total_order_cost) > 100