SELECT   facility_name, MIN(score) as min_score
FROM     los_angeles_restaurant_health_inspections
WHERE    facility_address ILIKE '%HOLLYWOOD BLVD%'
GROUP BY facility_name
ORDER BY min_score desc, facility_name