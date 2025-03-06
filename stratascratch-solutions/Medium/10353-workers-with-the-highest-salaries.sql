WITH ranked_salaries as (
    SELECT *, DENSE_RANK() OVER(ORDER BY salary desc) as d_rn
    FROM   worker w JOIN title t ON w.worker_id=t.worker_ref_id
)
SELECT worker_title as best_paid_title
FROM   ranked_salaries
WHERE  d_rn=1


-- OR --

WITH cte as (
    SELECT MAX(salary) as max_salary
    FROM   worker
)
SELECT   w.worker_title as best_paid_title
FROM     worker w JOIN title t ON w.worker_id = t.worker_ref_id
                  JOIN cte c ON w.salary = c.max_salary
ORDER BY best_paid_title