SELECT   owner_name
FROM     la_restaurant_health_inspections
GROUP BY owner_name, facility_id
HAVING   COUNT(distinct grade) = 3 



-- NOTE: initially was doing this too : COUNT(facility_id) >= 1; instead had to just group by facility_id