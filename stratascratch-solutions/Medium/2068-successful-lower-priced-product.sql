WITH CTE as (
    SELECT   product_id
    FROM     online_orders
    GROUP BY 1
    HAVING   AVG(cost_in_dollars) >= 3 and COUNT(product_id) >= 2
)
SELECT c.product_id, p.brand_name
FROM   online_products p JOIN CTE c ON p.product_id=c.product_id




-- solution 2: without CTE

SELECT   o.product_id, p.brand_name
FROM     online_products p JOIN online_orders o ON p.product_id=o.product_id
GROUP BY 1, 2
HAVING   AVG(cost_in_dollars) >= 3 and COUNT(o.product_id) >= 2