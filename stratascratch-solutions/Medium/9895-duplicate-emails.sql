SELECT   email
FROM     employee
GROUP BY email
HAVING   COUNT(*) > 1