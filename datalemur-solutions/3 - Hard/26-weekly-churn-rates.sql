-- Facebook is analyzing its user signup data for June 2022. Write a query to generate the churn rate by week in June 2022. 

-- Output the week number (1, 2, 3, 4, ...) and the corresponding churn rate rounded to 2 decimal places.
-- For example, week number 1 represents the dates from 30 May to 5 Jun, and week 2 is from 6 Jun to 12 Jun.

-- Assumptions:
-- If the last_login date is within 28 days of the signup_date, the user can be considered churned.
-- If the last_login is more than 28 days after the signup date, the user didn't churn.

-- users Table:

-- Column Name	Type
-- user_id	     integer
-- signup_date	datetime
-- last_login	datetime

-- users Example Input:

-- user_id	signup_date	last_login
-- 1001	06/01/2022 12:00:00	07/05/2022 12:00:00
-- 1002	06/03/2022 12:00:00	06/15/2022 12:00:00
-- 1004	06/02/2022 12:00:00	06/15/2022 12:00:00
-- 1006	06/15/2022 12:00:00	06/27/2022 12:00:00
-- 1012	06/16/2022 12:00:00	07/22/2022 12:00:00

-- Example Output:

-- signup_week	churn_rate
-- 1	66.67
-- 3	50.00


-- Explanation:

-- User ids 1001, 1002, and 1004 signed up in the first week of June 2022. 
-- Out of the 3 users, 1002 and 1004's last login is within 28 days from the signup date, hence they are churned users.
-- To calculate the churn rate, we take churned users divided by total users signup in the week. Hence 2 users / 3 users = 66.67%.




WITH weekly_signups AS (
    SELECT EXTRACT(WEEK FROM signup_date) AS signup_week,
           user_id,
           signup_date,
           last_login
    FROM   users
    WHERE  signup_date >= '2022-06-01' AND signup_date < '2022-07-01'
),
churn_calculation AS (
    SELECT   signup_week,
             COUNT(user_id) AS total_users,
             SUM(CASE WHEN last_login <= signup_date + INTERVAL '28 days' THEN 1 ELSE 0 END) AS churned_users
    FROM     weekly_signups
    GROUP BY 1
)
SELECT   signup_week,
         ROUND(100.0 * churned_users / total_users, 2) AS churn_rate
FROM     churn_calculation
ORDER BY 1



-- NOTE: 

-- if we want the week number to be just for the month of June, we can do the following: 
-- FLOOR(EXTRACT(DAY FROM signup_date - DATE '2022-06-01') / 7 + 1)