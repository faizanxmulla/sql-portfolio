-- Solution 1: using UNION ALL

SELECT SUM(number) as sum
FROM   transportation_numbers
WHERE  index < 5
UNION ALL
SELECT SUM(number)
FROM   transportation_numbers
WHERE  index > 5



-- Solution 2: using UNNEST(ARRAY ...)

SELECT UNNEST(ARRAY[
       SUM(CASE WHEN index < 5 THEN number ELSE 0 END),
       SUM(CASE WHEN index > 5 THEN number ELSE 0 END)
])
FROM   transportation_numbers