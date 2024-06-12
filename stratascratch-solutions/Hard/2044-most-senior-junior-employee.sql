WITH max_min_date AS (
    SELECT MAX(hire_date) as max, MIN(hire_date) AS min
    FROM   uber_employees
)
SELECT   COUNT(*) FILTER(WHERE hire_date=max AND termination_date IS NULL) AS longest_tenured, 
         COUNT(*) FILTER(WHERE hire_date=min AND termination_date IS NULL) AS least_tenured,
         (max - min) AS days_between
FROM     uber_employees ue, max_min_date md
GROUP BY max, min