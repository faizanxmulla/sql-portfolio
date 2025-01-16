SELECT   c.id, c.first_name, MIN(o.total_order_cost) as lowest_order_price
FROM     customers c JOIN orders o ON c.id=o.cust_id
GROUP BY c.id, c.first_name



-- NOTE: solved on first attempt