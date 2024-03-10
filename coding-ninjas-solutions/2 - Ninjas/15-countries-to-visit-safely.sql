-- A telecommunications company wants to invest in new countries. 
-- The company intends to invest in the countries where the average call duration of the calls in this country is strictly greater than the global average call duration.

-- Write an SQL query to find the countries where this company can invest.



WITH CTE as (
    SELECT   co.name, AVG(duration)
    FROM     calls c JOIN person p on c.caller_id=p.id 
                     JOIN country co on co.country_code=left(p.phone_number, 3)
    GROUP BY 1
    HAVING   AVG(duration) > (
        SELECT AVG(duration)
        FROM   calls
    )      
)
SELECT name as country
FROM   CTE



-- remarks: couldn't figure out the 'HAVING' condition. 