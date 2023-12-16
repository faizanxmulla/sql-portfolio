SELECT product_name, SUM(unit) as unit
FROM Products p JOIN Orders o USING(product_id)
WHERE EXTRACT(MONTH FROM o.order_date) = "02" and EXTRACT(YEAR FROM o.order_date) = 2020
GROUP BY 1 
HAVING SUM(unit) >= 100