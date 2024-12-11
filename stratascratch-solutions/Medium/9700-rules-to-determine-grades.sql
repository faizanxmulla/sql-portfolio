SELECT   grade,
         MIN(score),
         MAX(score),
         CONCAT('Score > ', MIN(score) - 1, ' AND Score <= ', MAX(score), ' => Grade = ', grade) as rule
FROM     los_angeles_restaurant_health_inspections
GROUP BY grade
ORDER BY grade