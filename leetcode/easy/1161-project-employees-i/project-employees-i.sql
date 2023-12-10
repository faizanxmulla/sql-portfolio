SELECT p.project_id, ROUND(AVG(experience_years), 2) as average_years
FROM Project p LEFT JOIN Employee e ON p.employee_id = e.employee_id
GROUP BY project_id


# IFNULL not needed due to this statement in the description : 
# --> It's guaranteed that experience_years is not NULL.