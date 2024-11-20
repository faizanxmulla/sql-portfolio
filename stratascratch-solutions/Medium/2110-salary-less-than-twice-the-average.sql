SELECT   h.manager_empl_id,
         mgr.salary as manager_salary,
         AVG(emp.salary) as avg_employee_salary
FROM     map_employee_hierarchy h JOIN dim_employee mgr ON h.manager_empl_id = mgr.empl_id
                                  JOIN dim_employee emp ON h.empl_id = emp.empl_id
GROUP BY 1, 2
HAVING   mgr.salary < 2 * AVG(emp.salary)



-- NOTE: solved on first attempt