SELECT mgr.employee_id, mgr.name, COUNT(emp.reports_to) as reports_count, ROUND(AVG(emp.age), 0) as average_age

FROM Employees emp, Employees mgr 
WHERE mgr.employee_id = emp.reports_to
GROUP BY 1
ORDER BY 1


# first approach (doesn't work): 

# SELECT employee_id, name, COUNT(reports_to) as reports_count, ROUND(AVG(age), 0) as average_age
# FROM Employees emp

# GROUP BY 1 
# HAVING COUNT(reports_to) > 1