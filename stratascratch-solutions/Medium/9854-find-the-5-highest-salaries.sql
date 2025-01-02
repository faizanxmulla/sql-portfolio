WITH CTE as (
    SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary desc) as rn
    FROM   worker
)
SELECT department, worker_id, salary
FROM   CTE
WHERE  rn=1