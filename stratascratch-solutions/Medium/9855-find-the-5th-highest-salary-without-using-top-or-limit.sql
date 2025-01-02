WITH CTE as (
    SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) as rn
    FROM worker
)
SELECT salary
FROM   CTE
WHERE  rn=5