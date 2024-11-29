SELECT   p.product_id,
         p.brand_name,
         customer_id,
         COUNT(customer_id) OVER(PARTITION BY p.product_id) as unique_cust_no
FROM     online_orders o JOIN online_products p ON o.product_id=p.product_id
WHERE    product_class='FURNITURE'
GROUP BY 1, 2, 3
ORDER BY 4 desc



-- NOTE: still same type as prev question #2149; not able to understand what is really being asked.