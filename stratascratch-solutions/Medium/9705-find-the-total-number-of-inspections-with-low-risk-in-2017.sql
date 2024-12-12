SELECT COUNT(*) as n_total_inspections
FROM   los_angeles_restaurant_health_inspections
WHERE  pe_description ilike '%LOW RISK'
       and activity_date BETWEEN '2017-01-01' and '2017-12-31'