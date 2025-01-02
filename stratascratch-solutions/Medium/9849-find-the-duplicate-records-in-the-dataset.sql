SELECT   worker_title, affected_from, COUNT(*) as n_affected
FROM     title
GROUP BY worker_title, affected_from
HAVING   COUNT(*) > 1



-- my initial solution: 
-- complicated it for no reason

WITH CTE as (
    SELECT worker_title,
           affected_from,
           ROW_NUMBER() OVER(PARTITION BY worker_title, affected_from) as rn
    FROM   title
)
SELECT   worker_title, affected_from, MAX(rn) as n_affected
FROM     CTE
GROUP BY worker_title, affected_from
HAVING   MAX(rn) > 1