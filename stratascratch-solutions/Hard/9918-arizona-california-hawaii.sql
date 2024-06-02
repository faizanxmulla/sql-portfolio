WITH arizona_employees AS (
    SELECT first_name, ROW_NUMBER() OVER(ORDER BY first_name) AS rn
    FROM   employee
    WHERE  city = 'Arizona'
),
california_employees AS (
    SELECT first_name, ROW_NUMBER() OVER(ORDER BY first_name) AS rn
    FROM   employee
    WHERE  city = 'California'
),
hawaii_employees AS (
    SELECT first_name, ROW_NUMBER() OVER(ORDER BY first_name) AS rn
    FROM   employee
    WHERE  city = 'Hawaii'
)
SELECT   a.first_name AS Arizona, 
         c.first_name AS California, 
         h.first_name AS Hawaii
FROM     arizona_employees a FULL OUTER JOIN california_employees c ON a.rn = c.rn
                             FULL OUTER JOIN hawaii_employees h ON a.rn = h.rn
ORDER BY COALESCE(a.rn, c.rn, h.rn)
