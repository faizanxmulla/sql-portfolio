WITH CTE as (
    SELECT   brand_name,
             customer_id,
             COUNT(customer_id) OVER(PARTITION BY brand_name) as customer_count
    FROM     online_orders o JOIN online_products p ON o.product_id=p.product_id
    WHERE    product_family = 'CONSUMABLE'
    GROUP BY 1, 2
)
SELECT   brand_name,
         ROUND(100 * customer_count / (SELECT COUNT(DISTINCT customer_id) FROM online_orders), 0) as pc_cust
FROM     CTE
GROUP BY 1, 2




-- my first attempt (wasn't able to understand the question properly) 

SELECT   p.brand_name,
         ROUND(100.0 * COUNT(customer_id) FILTER(WHERE p.product_family='CONSUMABLE') / COUNT(*), 0) as pc_cust
FROM     online_orders o JOIN online_products p ON o.product_id=p.product_id
GROUP BY 1
ORDER BY 2 DESC




-- NOTE: wasn't able to understand what is being asked in the question; otherwise it was an easy question. 