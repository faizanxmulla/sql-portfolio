WITH department_averages AS (
    SELECT   department,
             ROUND(AVG(salary)) AS avg_salary
    FROM     employee_o
    WHERE    id NOT IN (SELECT id FROM employee_o WHERE id = manager_id)
    GROUP BY 1
),
employee_manager_info AS (
    SELECT e.department,
           e.id,
           e.salary AS employee_salary,
           m.salary AS manager_salary
    FROM   employee_o e JOIN employee_o m ON e.manager_id = m.id
)
SELECT e.department,
       e.id,
       e.employee_salary,
       e.manager_salary,
       da.avg_salary,
FROM  employee_manager_info e JOIN department_averages da USING(department)
ORDER BY 1



-- my initial attempt:
-- got everything correct except the average part. 

SELECT e.department, 
       e.id, 
       e.salary AS employee_salary,
       m.salary AS manager_salary,
       AVG(e.salary) OVER(PARTITION BY e.department) AS avg_salary,
FROM   employee_o e JOIN employee_o m ON e.manager_id=m.id

