SELECT   title, 
         CASE 
            WHEN SUM(salary) * ((TIMESTAMPDIFF(DAY, start_date, end_date)) / 365) > budget 
            THEN 'overbudget' 
            ELSE 'within budget' 
         END as project_forecast
FROM     projects p JOIN employee_projects ep ON p.id = ep.project_id
                    JOIN employees e ON e.id = ep.employee_id
GROUP BY project_id, title



-- initial attempt

WITH CTE as (
    SELECT   p.title as project_title,
             p.budget as project_budget, 
             EXTRACT(EPOCH FROM end_date-start_date) / (365 * 86400) as project_duration_years,
             SUM(e.salary) as combined_employee_salary,
    FROM     employees e JOIN employee_projects ep ON e.id=ep.employee_id
                         JOIN projects p ON ep.project_id=p.id
    GROUP BY 1, 2, start_date, end_date
)
SELECT project_title, 
       CASE WHEN combined_employee_salary * project_duration > project_budget_years THEN 'overbudget' ELSE 'within budget' END as project_forecast
FROM   CTE 