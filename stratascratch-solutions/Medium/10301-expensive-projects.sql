SELECT   title as project,
         ROUND((1.0 * budget / COUNT(emp_id))) as budget_emp_ratio
FROM     ms_projects a LEFT JOIN ms_emp_projects b ON a.id = b.project_id
GROUP BY title, budget
HAVING   COUNT(emp_id) > 0 
ORDER BY budget_emp_ratio desc



-- NOTE: didnt write the HAVING clause initially (wrote later as was facing a zero-division error)