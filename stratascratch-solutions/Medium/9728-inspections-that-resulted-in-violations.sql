SELECT   EXTRACT(YEAR FROM inspection_date) as year,
         COUNT(*) FILTER(WHERE violation_id IS NOT NULL) as n_inspections
FROM     sf_restaurant_health_violations
WHERE    business_name='Roxanne Cafe'
GROUP BY year
ORDER BY year



-- NOTE: solved on first attempt