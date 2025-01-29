-- Solution 1: using HAVING clause

SELECT   id, name, created_at
FROM     users
GROUP BY 1, 2, 3
HAVING   COUNT(*) > 1


-- Solution 2: using ROW_NUMBER() function

WITH CTE as (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY created_at) as rn
	FROM   users
    )
SELECT id, name, created_at
FROM   CTE
WHERE  rn > 1