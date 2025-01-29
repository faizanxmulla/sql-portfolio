WITH ranked_flights as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY LEAST(source_location, destination_location), GREATEST(source_location, destination_location) ORDER BY flight_end - flight_start DESC) AS rn
    FROM   flights
)
SELECT id, destination_location, source_location, flight_start, flight_end
FROM   ranked_flights
WHERE  rn=2


-- NOTE: 
-- use of LEAST and GREATEST functions is intuitive.