WITH ranked_salaries AS (
    SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rn
    FROM   twitter_employee
)
SELECT id, CONCAT(first_name, ' ', last_name) as full_name, department, salary
FROM   ranked_salaries
WHERE  rn <= 3


-- remarks: suprisingly easy problem in the "Hard" section.