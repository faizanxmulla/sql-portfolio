SELECT   owner_name, 
         PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY score) AS q1,
         PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY score) AS q2,
         PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY score) AS q3,
         PERCENTILE_CONT(1.0) WITHIN GROUP(ORDER BY score) AS q4
FROM     los_angeles_restaurant_health_inspections
GROUP BY 1
-- ORDER BY (q1+q2+q3+q4) / 4


-- NOTE: works without "ORDER BY" also.