WITH CTE as (
    SELECT   EXTRACT(MONTH FROM order_date) as month,
             SUM(unit_price * quantity) as sales
    FROM     amazon_books ab JOIN book_orders bo ON ab.book_id = bo.book_id
    WHERE    order_date BETWEEN '2022-01-01' and '2022-12-31'
    GROUP BY month
    ORDER BY month
)
SELECT month, 
       sales, 
       ROUND(AVG(sales) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) AS avg_sales
FROM   CTE