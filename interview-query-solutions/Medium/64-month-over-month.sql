WITH CTE as (
    SELECT   EXTRACT(MONTH FROM created_at) as month, 
             SUM(price*quantity) as revenue
    FROM     transactions t JOIN products p ON t.product_id=p.id
    WHERE    EXTRACT(YEAR FROM created_at) = '2019'
    GROUP BY 1
)
SELECT month, 
       ROUND((revenue - LAG(revenue) OVER(ORDER BY month))/ LAG(revenue) OVER(ORDER BY month), 2) as month_over_month 
FROM   CTE