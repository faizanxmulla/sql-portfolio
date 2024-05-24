WITH ranked_salaries AS (
    SELECT *, DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS dr
    FROM   employee
)
SELECT   department_name, name, salary
FROM     ranked_salaries rs JOIN department d USING(department_id)
WHERE    dr <= 3
ORDER BY department_id, 3 DESC, 2



-- remarks: was using RANK instead of DENSE_RANK, again !!