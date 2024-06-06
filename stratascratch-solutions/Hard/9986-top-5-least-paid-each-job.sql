WITH ranked_employee_salaries AS (
    SELECT employeename, 
          jobtitle,
          totalpaybenefits,
          DENSE_RANK() OVER(PARTITION BY jobtitle ORDER BY totalpaybenefits) AS top_5_lowest
    FROM   sf_public_salaries
)
SELECT employeename, jobtitle, totalpaybenefits
FROM   ranked_employee_salaries
WHERE  top_5_lowest <= 5


-- NOTE: similar to #9981, just addition of PARTITION BY jobtitle.