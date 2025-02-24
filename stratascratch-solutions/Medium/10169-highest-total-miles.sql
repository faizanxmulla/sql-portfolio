WITH ranked_purposes as (
    SELECT   purpose, 
             SUM(miles) as miles_sum,
             RANK() OVER(ORDER BY SUM(miles) desc) as rn
    FROM     my_uber_drives
    WHERE    category ILIKE '%business%'
             and purpose IS NOT NULL
    GROUP BY purpose
)
SELECT purpose, miles_sum
FROM   ranked_purposes
WHERE  rn <= 3



-- NOTE: didnt put the FILTER condition earlier.