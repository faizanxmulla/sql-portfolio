-- Solution 1:
-- gives correct answer i.e. user_id - 1 & 4

WITH monthly_trips AS (
    SELECT   driver_id,
             DATE_TRUNC('month', trip_date)::DATE AS month
    FROM     uber_trips
    WHERE    is_completed = TRUE
    GROUP BY 1, 2
),
consecutive_months AS (
    SELECT driver_id, 
           month,
           (month - INTERVAL '1 month' * (ROW_NUMBER() OVER(PARTITION BY driver_id ORDER BY month)))::DATE AS month_group
    FROM   monthly_trips
)
SELECT   driver_id
FROM     consecutive_months
GROUP BY 1, month_group
HAVING   COUNT(*) >= 2




-- Solution 2: 
-- giving wrong answer for ig some edge case (answer given: user_id - 1); but more easiy understandable.

WITH monthly_trips AS (
    SELECT   driver_id,
             EXTRACT(MONTH FROM trip_date) AS month,
             COUNT(trip_id) AS trip_count
    FROM     uber_trips
    WHERE    is_completed = TRUE
    GROUP BY 1, 2
),
consecutive_months AS (
    SELECT driver_id,
           month,
           LAG(month, 1) OVER(PARTITION BY driver_id ORDER BY month) AS prev_month,
           LAG(month, 2) OVER(PARTITION BY driver_id ORDER BY month) AS prev_prev_month
    FROM   monthly_trips
),
qualified_drivers AS (
    SELECT DISTINCT driver_id
    FROM   consecutive_months
    WHERE  (month = prev_month + 1 AND prev_month IS NOT NULL) OR 
           (month = prev_month + 1 AND 
            prev_month = prev_prev_month + 1 AND 
            prev_prev_month IS NOT NULL)
)
SELECT driver_id
FROM   qualified_drivers;


