WITH curr_month_cte AS (
    SELECT   TO_CHAR(created_at, 'YYYY-MM') AS year_month,
             SUM(value) AS curr_month_value
    FROM     sf_transactions
    GROUP BY 1
    ORDER BY 1
),
prev_month_cte AS (
    SELECT *, LAG(curr_month_value) OVER(ORDER BY year_month) as prev_month_value
    FROM   curr_month_cte
)
SELECT year_month, 
       ROUND(100.0 * (curr_month_value - prev_month_value) / prev_month_value, 2) AS revenue_diff_pct
FROM   prev_month_cte