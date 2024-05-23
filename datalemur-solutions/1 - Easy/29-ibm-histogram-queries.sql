WITH queries_cte AS (
    SELECT   e.employee_id,
             COALESCE(COUNT(DISTINCT q.query_id), 0) AS unique_queries
    FROM     employees e LEFT JOIN queries q 
             ON e.employee_id = q.employee_id AND 
             EXTRACT(QUARTER FROM query_starttime)='3'
    GROUP BY 1
)
SELECT   unique_queries,
         COUNT(employee_id) AS employee_count
FROM     queries_cte
GROUP BY 1
ORDER BY 1



-- NOTE: was messing up the LEFT JOIN part and using the quarter condition in the WHERE clause.

-- REASONING : Effect of the WHERE Clause:

-- - The WHERE clause is applied after the join. This means that if an employee has no queries, the query_starttime for that employee will be NULL.

-- - So, employees with no queries in the third quarter are not counted at all, leading to incorrect results.


-- my first approach: 

WITH queries_cte AS (
    SELECT   e.employee_id,
             COALESCE(COUNT(DISTINCT q.query_id), 0) AS unique_queries
    FROM     employees e LEFT JOIN queries q USING(employee_id)
    WHERE    EXTRACT(QUARTER FROM query_starttime)='3'
    GROUP BY 1
)
SELECT   unique_queries,
         COUNT(employee_id) AS employee_count
FROM     queries_cte
GROUP BY 1