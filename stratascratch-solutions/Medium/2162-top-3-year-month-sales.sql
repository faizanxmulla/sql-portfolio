WITH ranked_orders as (
    SELECT   TO_CHAR(order_date, 'YYYY-MM') as sales_month,
             SUM(order_value) as total_sales,
             RANK() OVER(ORDER BY SUM(order_value) desc) as rn
    FROM     fct_customer_sales
    GROUP BY 1
)
SELECT sales_month, total_sales
FROM   ranked_orders
WHERE  rn <= 3