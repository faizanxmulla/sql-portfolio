-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.



WITH ranked_salaries AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Company ORDER BY Salary) AS rn,
           COUNT(*) OVER (PARTITION BY Company) AS total_count
    FROM   Employee
)
SELECT id, Company, Salary
FROM   ranked_salaries
WHERE  rn = CEILING(total_count / 2.0) OR rn = FLOOR(total_count / 2.0) + 1