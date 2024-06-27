-- Solution 1: 
-- more instinctive solution.

SELECT   company, PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Salary) AS median
FROM     employee_salaries
GROUP BY 1


-- Solution 2 : 
-- more correct solution according to the question asked, also get the bonus marks for not using built in SQL function. 

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS rn,
           COUNT(*) OVER(PARTITION BY company) AS cnt
    FROM   employee
)
SELECT id, company, salary
FROM   CTE
WHERE  rn BETWEEN cnt/2 AND cnt/2 + 1