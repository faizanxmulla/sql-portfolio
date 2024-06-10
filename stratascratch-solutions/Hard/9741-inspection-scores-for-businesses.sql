SELECT   business_name, PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY inspection_score) AS median
FROM     sf_restaurant_health_violations
WHERE    inspection_score IS NOT NULL
GROUP BY 1, inspection_score
ORDER BY inspection_score DESC