WITH relevant_employees AS (
    SELECT   jobtitle, 
             COUNT(employeename) FILTER(WHERE benefits=0) AS employees_wo_benefits,
             COUNT(*) AS total_employees
    FROM     sf_public_salaries
    GROUP BY 1
)
SELECT  jobtitle, 
        employees_wo_benefits,
        total_employees,
        (1.0 * employees_wo_benefits / total_employees) AS benefits_ratio
FROM     relevant_employees
ORDER BY 4


-- REMARKS: 
-- i was using this earlier - SUM(CASE WHEN benefits>0 THEN 0 ELSE 1 END) AS employees_wo_benefits, instead of the COUNT() FILTER ...