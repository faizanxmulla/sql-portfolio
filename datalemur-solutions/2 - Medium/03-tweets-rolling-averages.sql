-- Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.

-- Notes:

-- - A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
-- - In this case, we want to determine how the tweet count for each user changes over a 3-day period.



-- my solution : 

with cte as (
  SELECT user_id,
         tweet_count,
         LAG(tweet_count, 2) over(partition by user_id order by tweet_date) as prev_prev_date,
         LAG(tweet_count) over(partition by user_id order by tweet_date) as prev_date,
         tweet_date
  FROM   tweets
)
select user_id, 
       tweet_date, 
       CASE 
           WHEN prev_date IS NULL AND prev_prev_date IS NULL 
            THEN ROUND(tweet_count, 2)
           WHEN prev_date IS NULL 
            THEN ROUND((prev_prev_date + tweet_count) / 2.0, 2)
           WHEN prev_prev_date IS NULL 
            THEN ROUND((prev_date + tweet_count) / 2.0, 2)
         ELSE ROUND((prev_date + prev_prev_date + tweet_count) / 3.0, 2)
       END AS rolling_avg_3d
from   cte


-- datalemur official solution: 

SELECT user_id,    
       tweet_date,   
       ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) as rolling_avg_3d
FROM tweets


-- solution 3: similar to 1, but uses 'COALESCE'

WITH cte
     AS (SELECT user_id,
                tweet_date,
                tweet_count,
                COALESCE(Lag(tweet_count, 1)
                           OVER (
                             partition BY user_id
                             ORDER BY tweet_date), 0) AS lag1,
                COALESCE(Lag(tweet_count, 2)
                           OVER (
                             partition BY user_id
                             ORDER BY tweet_date), 0) AS lag2
         FROM   tweets)
SELECT user_id,
       tweet_date,
       Round(Cast(( tweet_count + lag1 + lag2 )AS NUMERIC) / (
             1 + CASE WHEN lag1!=0 THEN 1 ELSE 0 END + CASE WHEN lag2!=0 THEN 1
             ELSE 0
             END
                 ), 2) AS rolling_avg_3d
FROM   cte; 



-- remarks: good question; got to learn many new things like: 
-- a. ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- b. this also can be done : 1 + CASE WHEN lag1!=0 THEN 1 ELSE 0 END + CASE WHEN lag2!=0 THEN 1 ELSE 0