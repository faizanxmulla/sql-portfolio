WITH latest_month_cte AS (
	SELECT   *, MAX(month) OVER(PARTITION BY id) as latest_month
	FROM     employee
)
SELECT   id, 
         month, 
	     SUM(salary) OVER(PARTITION BY id
						  ORDER BY month
						  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as cumulative_salary
FROM     latest_month_cte
WHERE    month < latest_month
ORDER BY 1, 2 DESC