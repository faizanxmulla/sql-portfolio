SELECT   inspection_date,
         COUNT(violation_id) - LAG(COUNT(violation_id)) OVER(ORDER BY inspection_date) as diff
FROM     sf_restaurant_health_violations
GROUP BY inspection_date
ORDER BY inspection_date