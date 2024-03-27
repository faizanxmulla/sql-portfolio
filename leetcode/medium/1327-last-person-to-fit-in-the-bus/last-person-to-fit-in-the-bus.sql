with cumulative_weight as (
    SELECT *, sum(weight) over(order by turn)
    FROM   Queue
)
SELECT   person_name
FROM     cumulative_weight
WHERE    sum <= 1000
ORDER BY turn desc
LIMIT    1



-- some other approaches: 

-- SELECT   q1.person_name
-- FROM     Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
-- GROUP BY q1.turn
-- HAVING   SUM(q2.weight) <= 1000
-- ORDER BY SUM(q2.weight) DESC
-- LIMIT    1


-- SELECT   person_name 
-- FROM     queue AS q
-- WHERE    1000 >= (
--     SELECT SUM(weight) 
--     FROM   queue 
--     WHERE  q.turn >= turn
-- )
-- ORDER BY turn DESC 
-- LIMIT    1