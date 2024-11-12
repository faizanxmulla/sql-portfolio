SELECT   customer_id
FROM     online_orders o JOIN online_products p ON o.product_id=p.product_id
WHERE    brand_name IN ('Fort West', 'Golden')
GROUP BY 1
HAVING   COUNT(DISTINCT brand_name) = 2



-- NOTE: solved in first attempt