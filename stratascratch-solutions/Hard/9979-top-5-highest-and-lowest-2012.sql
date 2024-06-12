WITH ranked_employee_salaries AS (
    SELECT employeename, 
           totalpaybenefits,
           RANK() OVER(ORDER BY totalpaybenefits DESC) AS top_5_highest,
           RANK() OVER(ORDER BY totalpaybenefits) AS top_5_lowest
    FROM   sf_public_salaries
)
SELECT employeename, totalpaybenefits
FROM   ranked_employee_salaries
WHERE  top_5_lowest <= 5 OR top_5_highest <= 5