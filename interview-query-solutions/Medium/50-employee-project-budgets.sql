WITH get_employee_count as (
    SELECT   project_id, COUNT(*) as n_employees
    FROM     employee_projects
    GROUP BY project_id
)
SELECT   p.title, 1.0 * budget/n_employees as budget_per_employee
FROM     get_employee_count gc JOIN projects p ON gc.project_id=p.id
ORDER BY budget_per_employee desc
LIMIT    5