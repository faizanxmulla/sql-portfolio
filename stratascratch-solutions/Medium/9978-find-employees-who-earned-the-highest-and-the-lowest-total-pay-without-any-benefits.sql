WITH ranked_employees as (
    SELECT employeename, 
           totalpay, 
           RANK() OVER(ORDER BY totalpay desc) as rn_desc,
           RANK() OVER(ORDER BY totalpay) as rn
    FROM   sf_public_salaries
    WHERE  benefits IS NULL or benefits=0
)
SELECT employeename, totalpay
FROM   ranked_employees
WHERE  rn_desc=1 or rn=1



-- NOTE: initially didnt put the WHERE condition.