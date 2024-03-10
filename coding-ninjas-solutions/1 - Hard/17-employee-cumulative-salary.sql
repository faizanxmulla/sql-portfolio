-- Write an SQL query to calculate the cumulative salary summary for every employee in a single unified table.

-- The cumulative salary summary for an employee can be calculated as follows:

-- - For each month that the employee worked, sum up the salaries in that month and the previous two months. This is their 3-month sum for that month. 

-- - If an employee did not work for the company in previous months, their effective salary for those months is 0.
-- - Do not include the 3-month sum for the most recent month that the employee worked for in the summary.
-- - Do not include the 3-month sum for any month the employee did not work.
-- - Return the result table ordered by Id in ascending order. 
-- - In case of a tie, order it by Month in descending order.



-- leads to accepted solution: 

WITH latest_month_per_employee AS (
    SELECT   id, Max(month) AS month
    FROM     employee
    GROUP BY id
    HAVING   Count(*) > 1)
SELECT   E1.id,
         E1.month,
         COALESCE(E1.salary, 0) + COALESCE(E2.salary, 0) + COALESCE(E3.salary, 0) as Salary
FROM     latest_month_per_employee latestmonth LEFT JOIN employee E1 ON latestmonth.id = E1.id AND latestmonth.month > E1.month
                                             LEFT JOIN employee E2 ON E2.id = E1.id AND E2.month = E1.month - 1
                                             LEFT JOIN employee E3 ON E3.id = E1.id AND E3.month = E1.month - 2
ORDER BY 1, 2 desc



-- another approach: (but not accepted)

WITH MonthlySalaries AS (
    SELECT *, SUM(Salary) OVER (PARTITION BY Id ORDER BY Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS CumulativeSalary
    FROM   Employee
),
LatestMonth AS (
    SELECT   Id, MAX(Month) AS LatestMonth
    FROM     Employee
    GROUP BY 1
)
SELECT   m.Id, m.Month, m.CumulativeSalary
FROM     MonthlySalaries m JOIN LatestMonth lm ON m.Id = lm.Id
WHERE    m.Month <> lm.LatestMonth
ORDER BY m.Id ASC, m.Month DESC



-- my approach: had an idea for excluding the most recent month; but couldn't figure out on how to adrress the not working conditions.

SELECT *, RANK() OVER(PARTITION BY id ORDER BY month desc)
FROM   employee



-- remarks: 
-- "ROWS BETWEEN 2 PRECEDING AND CURRENT ROW" --> important to remember
