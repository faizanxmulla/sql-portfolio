-- Given a table WORKERS, find how many workers have the maximum total earnings among all the WORKERS.

-- The total earnings of a worker is calculated as Daily Wage * Number of Days Worked.


-- Solution : 

SELECT Count(*) AS A
FROM   WORKERS
WHERE  (DailyWage * DaysWorked) = (SELECT Max(DailyWage * DaysWorked)
                                   FROM   WORKERS) 


-- my approaches : 

SELECT MAX(DailyWage * DaysWorked)
FROM (
    SELECT COUNT(*) as A
    FROM WORKERS
) x

SELECT   COUNT(*) as A
FROM     WORKERS
ORDER BY (DailyWage*DaysWorked) DESC
LIMIT    1