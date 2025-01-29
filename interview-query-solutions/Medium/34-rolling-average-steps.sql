-- working solution: 

WITH CTE AS (
    SELECT user_id, 
           date, 
           AVG(steps) OVER(PARTITION BY user_id ORDER BY date 
                           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_steps,
           LAG(date) OVER(PARTITION BY user_id ORDER BY date) AS prev_date,
           LAG(date, 2) OVER(PARTITION BY user_id ORDER BY date) AS prev2_date
    FROM   daily_steps
)
SELECT user_id, date, ROUND(avg_steps) AS avg_steps
FROM   CTE
WHERE  date - prev_date = 1 
       and date - prev2_date = 2;




-- not working solutions

-- Solution 1: using ROWS BETWEEN clause and ROW_NUMBER() to filter

WITH CTE as (
    SELECT user_id, 
           date, 
           AVG(steps) OVER(PARTITION BY user_id ORDER BY date
                           ROWS BETWEEN 2 PRECEDING and CURRENT ROW) as avg_steps,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date) as rn
    FROM   daily_steps
)
SELECT user_id, date, ROUND(avg_steps) as avg_steps
FROM   CTE 
WHERE  rn > 2



-- Solution 2: using LAG()

WITH CTE as (
    SELECT user_id,
           date,
           steps,
           LAG(date, 1) OVER (PARTITION BY user_id ORDER BY date) as prev_date,
           LAG(date, 2) OVER (PARTITION BY user_id ORDER BY date) as prev2_date
    FROM daily_steps
)
SELECT user_id,
       date,
       ROUND(AVG(steps) OVER (PARTITION BY user_id ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS avg_steps
FROM   CTE
WHERE  prev_date = date - INTERVAL '1 DAY'
       and prev2_date = date - INTERVAL '2 DAY'



-- NOTE: both don't satisfy all the testcases. 

-- '1' is failing the last testcase. 
-- '2' is giving error in the single inverted comma around INTERVAL.