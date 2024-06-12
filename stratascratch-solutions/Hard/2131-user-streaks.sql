WITH cte AS (
    SELECT user_id, 
           date_visited,
           date_visited - ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date_visited)::INTEGER AS rn
    FROM   user_streaks
    WHERE  date_visited <= '2022-08-10'
),
cte1 AS (
    SELECT   user_id, rn, COUNT(*) AS frequency
    FROM     cte
    GROUP BY 1, 2
    ORDER BY 1, 2
),
cte2 AS (
    SELECT   user_id, 
             MAX(frequency) AS longest_streak, 
             DENSE_RANK() OVER(ORDER BY MAX(frequency) DESC) AS dr
    FROM     cte1
    GROUP BY 1
)
SELECT   user_id, longest_streak
FROM     cte2
WHERE    dr <= 3
ORDER BY 2 DESC


-- REMARKS: important question.