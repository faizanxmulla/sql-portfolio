WITH ranked_orders as (
    SELECT   cust_id,
             SUM(total_order_cost),
             DENSE_RANK() OVER(ORDER BY SUM(total_order_cost) desc) as rn  
    FROM     card_orders 
    GROUP BY cust_id
)
SELECT id, first_name, last_name
FROM   ranked_orders ro JOIN customers c ON ro.cust_id=c.id 
WHERE  rn=3



-- NOTE: solved on first attempt