WITH cte1 AS (
    SELECT player_id,
           ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_date) AS match_num,
           match_result
    FROM   players_results
),
cte2 AS (
    SELECT player_id,
           match_num - ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_num) AS match_group
    FROM   cte1
    WHERE  match_result = 'W'
),
cte3 AS (
    SELECT   player_id, 
             match_group, 
             COUNT(*) AS streak
    FROM     cte2
    GROUP BY 1, 2
)
SELECT   DISTINCT player_id, streak
FROM     cte3
WHERE    streak IN (
          SELECT MAX(streak) 
          FROM   cte3
          )
ORDER BY 1
