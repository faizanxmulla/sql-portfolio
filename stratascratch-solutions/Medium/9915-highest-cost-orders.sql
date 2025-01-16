WITH ranked_orders_cost as (
    SELECT   c.first_name, 
             o.order_date, 
             SUM(o.total_order_cost) as total_order_cost,
             ROW_NUMBER() OVER(ORDER BY SUM(o.total_order_cost) desc) as rn
    FROM     customers c JOIN orders o ON c.id=o.cust_id
    WHERE    o.order_date BETWEEN '2019-02-01' and '2019-05-01'
    GROUP BY c.first_name, o.order_date
)
SELECT first_name, order_date, total_order_cost
FROM   ranked_orders_cost
WHERE  rn=1