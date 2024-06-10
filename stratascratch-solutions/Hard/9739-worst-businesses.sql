WITH violations_cte AS (
    SELECT   EXTRACT(YEAR FROM inspection_date) AS year,
             business_name, 
             COUNT(violation_id) AS violations_count
    FROM     sf_restaurant_health_violations
    GROUP BY 1, 2
),
ranked_violations AS (
    SELECT   *, RANK() OVER(PARTITION BY year ORDER BY violations_count DESC) AS rn
    FROM     violations_cte
)
SELECT   year, business_name, SUM(violations_count) AS total_violations
FROM     ranked_violations
WHERE    rn=1
GROUP BY 1, 2