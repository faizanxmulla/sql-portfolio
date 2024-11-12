WITH CTE as (
    SELECT   product_class,
             RANK() OVER(ORDER BY count(units_sold) desc) as rn
    FROM     online_orders o JOIN online_products p ON o.product_id=p.product_id
    GROUP BY 1
)
SELECT product_class
FROM   CTE
WHERE  rn <= 3



