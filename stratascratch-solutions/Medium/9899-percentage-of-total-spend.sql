SELECT c.first_name,
       o.order_details,
       o.total_order_cost / 
       SUM(o.total_order_cost) OVER(PARTITION BY c.first_name)::float as percentage_total_cost
FROM   orders o JOIN customers c ON c.id = o.cust_id