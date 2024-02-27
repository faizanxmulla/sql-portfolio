-- Write an SQL query to find the salaries of the employees after applying taxes.

-- The tax rate is calculated for each company based on the following criteria:

--  - 0% If the max salary of any employee in the company is less than 1000$.
--  - 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
--  - 49% If the max salary of any employee in the company is greater than 10000$.

-- Return the result table in any order. Round the salary to the nearest integer.



WITH cte
     AS (SELECT *,
                Max(salary)
                  OVER(
                    partition BY company_id) AS max
         FROM   salaries)
SELECT company_id,
       employee_id,
       employee_name,
       Round(CASE
               WHEN max < 1000 THEN salary
               WHEN max BETWEEN 1000 AND 10000 THEN 0.76 * salary
               ELSE 0.51 * salary
             END) AS salary
FROM   cte 



-- remarks: solved in first attempt.