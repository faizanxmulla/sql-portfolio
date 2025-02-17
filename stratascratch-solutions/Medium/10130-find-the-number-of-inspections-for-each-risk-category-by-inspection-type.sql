SELECT   inspection_type,
         SUM(CASE WHEN risk_category IS NULL THEN 1 ELSE 0 END) as no_risk_results,
         SUM(CASE WHEN risk_category='Low Risk' THEN 1 ELSE 0 END) as low_risk_results,
         SUM(CASE WHEN risk_category='Moderate Risk' THEN 1 ELSE 0 END) as medium_risk_results,
         SUM(CASE WHEN risk_category='High Risk' THEN 1 ELSE 0 END) as high_risk_results,
         COUNT(*) as total_inspections
FROM     sf_restaurant_health_violations
GROUP BY inspection_type
ORDER BY total_inspections desc