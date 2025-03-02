SELECT   p.title, 
         p.budget, 
         CEIL(SUM(salary) * (p.end_date - p.start_date) / 365) as prorated_employee_expense
FROM     linkedin_employees e JOIN linkedin_emp_projects ep ON e.id=ep.emp_id
                              JOIN linkedin_projects p ON ep.project_id=p.id
GROUP BY p.title, p.budget, p.end_date, p.start_date
HAVING   p.budget < CEIL(SUM(salary) * (p.end_date - p.start_date) / 365)