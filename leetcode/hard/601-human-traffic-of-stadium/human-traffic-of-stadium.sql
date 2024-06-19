WITH grp_cte AS (
    SELECT *, id - ROW_NUMBER() OVER(ORDER BY id) AS grp_number
    FROM   Stadium
    WHERE  people >= 100
)
SELECT id, visit_date, people
FROM   grp_cte
WHERE  grp_number IN ( 
        SELECT   grp_number
        FROM     grp_cte
        GROUP BY 1
        HAVING   COUNT(1) >= 3
)


-- my initial approach: 

-- WITH id_cte AS (
--     SELECT *, 
--            LEAD(id) OVER(ORDER BY id) AS next_id,
--            LEAD(id, 2) OVER(ORDER BY id) AS next_next_id
--     FROM   Stadium
--     WHERE  people > 100
-- )
-- SELECT id, visit_date, people
-- FROM   id_cte
-- WHERE  next_id - id = 1 AND next_next_id - next_id = 1
