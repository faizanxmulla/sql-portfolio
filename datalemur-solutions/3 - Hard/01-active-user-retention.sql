-- Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

-- Hint:

-- An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.



WITH cte AS (
  SELECT user_id,
         EXTRACT(month FROM event_date) AS month,
         event_type
  FROM   user_actions
  WHERE EXTRACT(month FROM event_date) IN (6, 7) AND event_type IN ('sign-in', 'like', 'comment')
)
SELECT 7 AS month,
       COUNT(DISTINCT CASE WHEN month_count = 2 THEN user_id END) AS monthly_active_users
FROM   (
    SELECT   user_id,
             COUNT(DISTINCT month) AS month_count
    FROM     cte
    GROUP BY 1
) x



-- my approach: 

WITH cte AS (
       SELECT *,
              EXTRACT(month FROM event_date) AS current
       FROM   user_actions )
SELECT *
FROM   cte
WHERE  event_type IN ('sign-in', 'like', 'comment') AND current IN ('7','6')



-- remarks : not that tough, but couldn't figure out how to proceed.

