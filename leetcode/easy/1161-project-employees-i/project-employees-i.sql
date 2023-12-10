SELECT project_id, IFNULL(ROUND(AVG(experience_years), 2), 0) as average_years
FROM Project p LEFT JOIN Employee e ON p.employee_id = e.employee_id
GROUP BY project_id