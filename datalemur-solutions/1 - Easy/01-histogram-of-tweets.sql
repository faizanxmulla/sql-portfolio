-- Group the users by the number of tweets they posted in 2022 and count the number of users in each group.

-- Solution 1 : using subquery

SELECT  tweet_count_per_user AS tweet_bucket,
        Count(user_id)       AS users_num
FROM    (SELECT user_id,
                Count(tweet_id) AS tweet_count_per_user
         FROM   tweets
         WHERE  tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
         GROUP  BY 1) AS total_tweets
GROUP BY 1 


-- Solution 2 : using CTE

WITH total_tweets
     AS (SELECT   user_id,
                  Count(tweet_id) AS tweet_count_per_user
         FROM     tweets
         WHERE    tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
         GROUP BY 1)

SELECT   tweet_count_per_user AS tweet_bucket,
         Count(user_id)       AS users_num
FROM     total_tweets
GROUP BY 1; 


-- my first approach : to use substring or extract_year to get the tweets in 2022.

SELECT SUBSTRING(CAST(tweet_date AS VARCHAR),1, 4) as subs
FROM   tweets;

-- Approach towards the solution : 
-- First, we need to find the number of tweets posted by each user in 2022.

SELECT   user_id,
         Count(tweet_id) AS tweet_count_per_user
FROM     tweets
WHERE    tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY 1; 


