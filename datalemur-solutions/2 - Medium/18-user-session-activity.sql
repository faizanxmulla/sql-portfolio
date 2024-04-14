WITH CTE as (
    SELECT   user_id,
             session_type,
             SUM(duration) as total_duration
    FROM     sessions
    WHERE    EXTRACT(YEAR from duration)='2022' and EXTRACT(MONTH from duration)='01'
    GROUP BY 1, 2
)
SELECT user_id,
       session_type,
       DENSE_RANK OVER(PARTITION BY session_type ORDER BY duration desc) as ranking
FROM   CTE

