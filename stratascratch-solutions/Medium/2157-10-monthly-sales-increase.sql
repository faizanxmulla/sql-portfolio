WITH CTE as (
    SELECT   product_id, 
             SUM(units_sold*cost_in_dollars) FILTER (WHERE EXTRACT(MONTH FROM date) = 4) as april_sales,
             SUM(units_sold*cost_in_dollars) FILTER(WHERE EXTRACT(MONTH FROM date) = 5) as may_sales
    FROM     online_orders
    GROUP BY product_id
)
SELECT product_id, 100.0 * ((may_sales - april_sales) / april_sales) as pc_growth
FROM   CTE
WHERE  100.0 * ((may_sales - april_sales) / april_sales) > 10



-- NOTE: was getting wrong answer as was dividing by 'may_sales' in pc_growth formula.