WITH CTE AS (
    SELECT employeename, 
           jobtitle, 
           totalpay,
           AVG(totalpay) OVER(PARTITION BY jobtitle) as avg_pay,
           RANK() OVER(PARTITION BY jobtitle ORDER BY totalpay DESC) AS top_5_highest
    FROM   sf_public_salaries
    WHERE  year=2013
)
SELECT   DISTINCT employeename
FROM     CTE
WHERE    totalpay > avg_pay AND top_5_highest > 5
ORDER BY 1