WITH CTE AS (
    SELECT facility_name, 
           pe_description,
           COUNT(*) OVER(PARTITION BY pe_description) AS description_count
    FROM   los_angeles_restaurant_health_inspections
    WHERE  facility_name ~ '\y(CAFE|TEA|JUICE)\y' 
),
ranked_facilities AS (
    SELECT facility_name,
           DENSE_RANK() OVER(ORDER BY description_count DESC) AS dr
    FROM   CTE
)
SELECT facility_name
FROM   ranked_facilities
WHERE  dr=3