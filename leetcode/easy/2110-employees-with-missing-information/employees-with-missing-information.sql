WITH CTE AS (
    SELECT employee_id 
    FROM   Employees
    UNION
    SELECT employee_id 
    FROM   Salaries
)
SELECT employee_id 
FROM   CTE
WHERE  employee_id NOT IN (
        SELECT e.employee_id 
        FROM   Employees e JOIN Salaries s USING(employee_id)
        )
ORDER BY 1