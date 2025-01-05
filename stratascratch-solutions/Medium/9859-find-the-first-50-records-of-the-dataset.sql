WITH CTE as (
    SELECT *, PERCENT_RANK() OVER(ORDER BY worker_id) as percent_rank
    FROM   worker
)
SELECT worker_id, first_name, last_name, salary, joining_date, department
FROM   CTE
WHERE  percent_rank <= 0.5



-- NOTE: wasn't sure to use PERCENT_RANK()