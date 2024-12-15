SELECT   business_name, 
         MIN(inspection_score) as min_score,
         MAX(inspection_score) as max_score
FROM     sf_restaurant_health_violations
GROUP BY business_name
HAVING   MIN(inspection_score) <> MAX(inspection_score)
ORDER BY business_name