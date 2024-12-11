SELECT   owner_name
FROM     los_angeles_restaurant_health_inspections
GROUP BY owner_id, owner_name
HAVING   COUNT(distinct facility_id) = 1
ORDER BY owner_name



-- NOTE: wasn't grouping by owner_id (getting 212 records instead of 206)