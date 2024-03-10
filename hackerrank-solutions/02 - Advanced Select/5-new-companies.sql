-- comp_code, fiunder_name, #lead_mgrs, #senior_mngrs,


SELECT c.company_code, 
       c.founder, 
       count(distinct lm.lead_manager_code), 
       count(distinct sm.senior_manager_code), 
       count(distinct m.manager_code),
       count(distinct e.employee_code)
FROM Company c JOIN Lead_Manager lm USING(company_code)
               JOIN Senior_Manager sm USING(lead_manager_code)
               JOIN Manager m USING(senior_manager_code)
               JOIN Employee e USING(manager_code)
GROUP BY 1, 2
ORDER BY 1


-- remarks: JOINs lead to more process time; can use where conditions to reduce it. 