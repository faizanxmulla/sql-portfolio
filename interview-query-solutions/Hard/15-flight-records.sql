-- Solution 1: using LEAST and GREATEST functions

SELECT   LEAST(source_location, destination_location) as destination_one,
         GREATEST(source_location, destination_location) as destination_two
FROM     flights
GROUP BY 1, 2
ORDER BY 1, 2



-- Solution 2: using UNION ALL and DISTINCT 

WITH CTE as (
    SELECT source_location, destination_location
    FROM   flights
    UNION ALL
    SELECT destination_location, source_location
    FROM   flights
)
SELECT DISTINCT source_location as destination_one, destination_location as destination_two
FROM   CTE
WHERE  source_location <  destination_location



-- NOTE: very easy when using LEAST and GREATEST functions.