SELECT   distinct business_name, 
         COUNT(*) FILTER(WHERE risk_category IS NOT NULL) as number_of_violations
FROM     sf_restaurant_health_violations
WHERE    business_name ILIKE '%school%' and risk_category IS NOT NULL
GROUP BY business_name
ORDER BY number_of_violations desc



-- NOTE: didn't notice the school condition in the question at first.