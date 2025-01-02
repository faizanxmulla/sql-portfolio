-- Solution 1: using LIMIT

SELECT   worker_id, salary, department
FROM     worker
ORDER BY salary desc
LIMIT    11


-- OR 

-- Solution 2: using window_function:

WITH CTE as (
    SELECT *, RANK() OVER(ORDER BY salary DESC) as rn
    FROM worker
)
SELECT worker_id, department, salary
FROM   CTE
WHERE  rn < 11