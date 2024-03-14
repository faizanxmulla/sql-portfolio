-- Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.


-- GROUP BY activity_date
-- INTERVAL 'DAY' 90
-- for first time, use RANK()


-- Solution 1:

WITH ranked_activities as (
    SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY activity_date)
    FROM   Traffic
    WHERE  activity='login'
)

SELECT   activity_date as login_date, COUNT(user_id) as user_count
FROM     ranked_activities
WHERE    rank=1 and '2019-06-30' - activity_date <= 90
GROUP BY 1



-- Solution 2: 

SELECT   login_date,
         Count(user_id) AS user_count
FROM     (SELECT   user_id,
                   Min(activity_date) AS login_date
          FROM     traffic
          WHERE    activity = 'login'
          GROUP BY user_id) t
WHERE    '2019-06-30' :: DATE - login_date :: DATE <= 90
GROUP BY 1; 


-- remarks: solution 1 --> solved by self.