WITH department_avg_cte AS (
    SELECT   payment_date, 
             department_id,
             AVG(amount) AS avg_salary
    FROM     employee e JOIN salary s USING(employee_id)
    WHERE    TO_CHAR(payment_date, 'YYYY-MM')='2024-03'
    GROUP BY 1, 2
),
company_avg_cte AS (
    SELECT   payment_date,
             AVG(amount) AS overall_avg_salary
    FROM     salary
    WHERE    TO_CHAR(payment_date, 'MM-YYYY')='03-2024'
    GROUP BY 1
)
SELECT department_id, 
       TO_CHAR(payment_date, 'MM-YYYY') AS payment_date,
       CASE WHEN avg_salary > overall_avg_salary THEN 'higher'
            WHEN avg_salary < overall_avg_salary THEN 'lower'
            ELSE 'same' 
       END AS comparision
FROM   department_avg_cte d JOIN company_avg_cte c USING(payment_date)
