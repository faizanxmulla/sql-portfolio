WITH churn_count AS (
    SELECT   EXTRACT(YEAR FROM end_date) AS year,
             COUNT(*) FILTER(WHERE end_date IS NOT NULL) AS curr_year_churned
    FROM     lyft_drivers
    GROUP BY 1
    ORDER BY 1
),
prev_churn_count AS (
    SELECT *, LAG(curr_year_churned) OVER(ORDER BY year) as prev_year_churned
    FROM   churn_count
    WHERE  year IS NOT NULL
)
SELECT *, 
       CASE 
           WHEN prev_year_churned > curr_year_churned THEN 'decrease'
           WHEN prev_year_churned < curr_year_churned THEN 'increase'
           ELSE 'no change'
        END AS indication
FROM   prev_churn_count