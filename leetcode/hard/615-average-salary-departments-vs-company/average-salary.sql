WITH department_avg AS (
    SELECT   pay_date,
             department_id, 
             AVG(amount) AS avg_salary
    FROM     salary s JOIN employee e USING(employee_id)
    GROUP BY 1, 2
    ORDER BY 1, 2
),
company_avg AS (
    SELECT   pay_date,
             AVG(amount) AS company_avg_salary
    FROM     salary
    GROUP BY 1
)
SELECT   TO_CHAR(pay_date, 'YYYY-MM') AS pay_month,
         department_id,
         CASE WHEN avg_salary > company_avg_salary THEN 'higher'
              WHEN avg_salary < company_avg_salary THEN 'lower'
              ELSE 'same' 
         END AS comparision
FROM     department_avg da JOIN company_avg ca USING(pay_date)
ORDER BY 1 DESC


-- remarks: exactly similar to the #28 of the Hard section of DataLemur.