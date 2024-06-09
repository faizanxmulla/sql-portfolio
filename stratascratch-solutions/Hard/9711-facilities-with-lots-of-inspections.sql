WITH inspections_per_year AS (
    SELECT   facility_name,
             EXTRACT(YEAR FROM activity_date) AS year,
             COUNT(*) AS inspections_count
    FROM     los_angeles_restaurant_health_inspections
    GROUP BY 1, 2
),
max_inspections_per_facility AS (
    SELECT   facility_name,
             MAX(inspections_count) AS max_inspections
    FROM     inspections_per_year
    WHERE    year <> 2017
    GROUP BY 1
),
inspections_2017 AS (
    SELECT facility_name,
           inspections_count AS inspections_2017
    FROM   inspections_per_year
    WHERE  year = 2017
)
SELECT i2017.facility_name
FROM   inspections_2017 i2017 JOIN max_inspections_per_facility mipf USING(facility_name)
WHERE  i2017.inspections_2017 > mipf.max_inspections;



