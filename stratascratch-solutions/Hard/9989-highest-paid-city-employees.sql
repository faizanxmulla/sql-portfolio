WITH ranked_salaries AS (
    SELECT *, RANK() OVER(PARTITION BY jobtitle ORDER BY totalpaybenefits DESC) AS rn
    FROM   sf_public_salaries
)
SELECT   jobtitle,
         MAX(employeename) FILTER (WHERE rn = 1) AS highest_salary_emp,
         MAX(employeename) FILTER (WHERE rn = 2) AS second_salary_emp
FROM     ranked_salaries
GROUP BY 1