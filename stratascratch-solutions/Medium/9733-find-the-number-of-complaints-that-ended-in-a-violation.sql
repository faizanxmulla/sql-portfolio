SELECT COUNT(violation_id) as n_violations
FROM   sf_restaurant_health_violations
WHERE  inspection_type='Complaint'
       and risk_category IS NOT NULL



-- NOTE: didn't add the risk category conditon initially; but was still passing all testcases