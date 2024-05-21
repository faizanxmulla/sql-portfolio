-- As a data analyst at Uber, it's your job to report the latest metrics for specific groups of Uber users. 
-- Some riders create their Uber account the same day they book their first ride; the rider engagement team calls them "in-the-moment" users.

-- Uber wants to know the average delay between the day of user sign-up and the day of their 2nd ride. 

-- Write a query to pull the average 2nd ride delay for "in-the-moment" Uber users. Round the answer to 2-decimal places.

-- Tip:
-- You don't need to use date operations to get the answer! You're welcome to, but it's not necessary.

-- users Table:

-- Column Name	      Type
-- user_id	          integer
-- registration_date	date

-- users Example Input:

-- user_id	registration_date
-- 1	      08/15/2022
-- 2	      08/21/2022

-- rides Table:

-- Column Name	Type
-- ride_id	    integer
-- user_id	    integer
-- ride_date	  date

-- rides Example Input:

-- ride_id	user_id	ride_date
-- 1	      1	      08/15/2022
-- 2	      1	      08/16/2022
-- 3	      2	      09/20/2022
-- 4	      2	      09/23/2022

-- Example Output:

-- average_delay
-- 1

-- Explanation:
-- We do not include user 2 in the calculation because the user was not created on the same date as the first ride.
-- For user 1, the difference between the first and second rides was 1 day; thus, the overall average is 1 day.
-- The dataset you are querying against may have different input & output - this is just an example!




WITH users_cte AS (
    SELECT u.user_id,
           registration_date,
           ride_date, 
           RANK() OVER(PARTITION BY u.user_id ORDER BY r.ride_date) as rank
    FROM   users u JOIN rides r USING(user_id)
),
in_the_moment_cte AS (
    SELECT user_id, registration_date, ride_date 
    FROM   users_cte
    WHERE  rank = 1 AND registration_date=ride_date
),
second_ride_cte AS (
    SELECT user_id, u.registration_date, u.ride_date as second_ride_date
    FROM   in_the_moment_cte im JOIN users_cte u USING(user_id)
    WHERE  rank = 2
)
SELECT ROUND(AVG(second_ride_date - registration_date), 2) AS avg_delay
FROM   second_ride_cte;