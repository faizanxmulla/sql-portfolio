WITH ranked_orders as (
    SELECT   e.id, e.last_name, RANK() OVER(ORDER BY COUNT(o.order_id) desc) as rn
    FROM     shopify_orders o JOIN shopify_employees e ON o.resp_employee_id=e.id
    GROUP BY 1, 2
)
SELECT last_name
FROM   ranked_orders
WHERE  rn=1



-- NOTE: solved on second attempt; forgot the GROUP BY in the first run