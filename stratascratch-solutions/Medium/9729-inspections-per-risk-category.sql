SELECT   COALESCE(risk_category, 'No Risk'), COUNT(distinct inspection_id) as n_inspections
FROM     sf_restaurant_health_violations
GROUP BY risk_category



-- NOTE: solved on first attempt