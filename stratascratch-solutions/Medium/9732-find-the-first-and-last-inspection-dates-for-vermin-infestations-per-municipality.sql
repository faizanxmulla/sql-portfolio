SELECT   business_postal_code,
         MIN(inspection_date) as first_inspection,
         MAX(inspection_date) as last_inspection
FROM     sf_restaurant_health_violations
WHERE    violation_description ILIKE '%vermin%'
         and business_postal_code IS NOT NULL
GROUP BY business_postal_code



-- NOTE: missed the IS NOT NULL condition in the initial attempt