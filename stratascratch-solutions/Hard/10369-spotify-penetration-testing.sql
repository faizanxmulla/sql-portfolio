WITH CTE as (
    SELECT country,
           CASE
                WHEN last_active_date >= DATE('2024-01-31') - INTERVAL '30 days'
                     and sessions >= 5
                     and listening_hours >= 10 THEN 1
                ELSE 0
           END AS is_active
   FROM    penetration_analysis
)
SELECT   country,
         ROUND(1.0 * SUM(is_active) / COUNT(is_active), 2)
FROM     CTE
GROUP BY 1