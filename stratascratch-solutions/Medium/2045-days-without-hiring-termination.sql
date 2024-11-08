WITH CTE as (
    SELECT LEAD(hire_date) OVER(ORDER BY hire_date) - hire_date as hire_differential,
           LEAD(termination_date) OVER(ORDER BY termination_date) - termination_date as termination_differential
    FROM   uber_employees
)
SELECT MAX(hire_differential), MAX(termination_differential)
FROM   CTE



-- NOTE: 