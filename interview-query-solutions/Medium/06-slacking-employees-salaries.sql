WITH projects_cte AS (
    SELECT   employee_id, 
             COUNT(project_id) as total_projects, 
             COUNT(project_id) FILTER(WHERE End_dt IS NULL) as incomplete_projects
    FROM     projects
    GROUP BY 1
)
SELECT   SUM(salary) as total_slack_salary
FROM     projects_cte pc JOIN employees e ON e.id=pc.employee_id
WHERE    total_projects >= 1
         and total_projects=incomplete_projects



-- NOTE: solve in first attempt.