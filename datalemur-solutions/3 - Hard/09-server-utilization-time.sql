-- Amazon Web Services (AWS) is powered by fleets of servers. Senior management has requested data-driven solutions to optimize server usage.

-- Write a query that calculates the total time that the fleet of servers was running. The output should be in units of full DAYs.

-- Assumptions:

-- - Each server might start and stop several times.
-- - The total time in which the server fleet is running can be calculated as the sum of each server's uptime.



-- Approach 1: using EPOCH 

WITH CTE AS (
    SELECT   server_id, 
             session_status,
             status_time as start_time,
             LEAD(status_time) OVER(PARTITION BY server_id ORDER BY status_time) as stop_time
    FROM     server_utilization
    ORDER BY 1, 3
)
SELECT ROUND(SUM(EXTRACT(EPOCH FROM stop_time-start_time) / 86400)) as total_uptime_days
FROM   CTE
WHERE  session_status='start'



-- Approach 2: 

WITH CTE_1 AS (
    SELECT   server_id, 
             session_status,
             status_time as start_time,
             LEAD(status_time) OVER(PARTITION BY server_id ORDER BY status_time) as stop_time
    FROM     server_utilization
    ORDER BY 1, 3
), 
CTE_2 as (
    SELECT  EXTRACT(DAY FROM (stop_time - status_time)) as days, 
            EXTRACT(HOUR FROM (stop_time - status_time)) as hours 
    FROM    CTE 
    WHERE   session_status='start')
SELECT ROUND(SUM(days) + SUM(hours / 24)) as total_uptime_days 
FROM   CTE_2



-- Approach 3: using JUTIFY hours / also the official solution

WITH running_time AS (
  SELECT server_id, 
         session_status, 
         status_time AS start_time,
         LEAD(status_time) OVER (PARTITION BY server_id ORDER BY status_time) AS stop_time
  FROM   server_utilization
)
SELECT DATE_PART('days', JUSTIFY_HOURS(SUM(stop_time - start_time))) AS total_uptime_DAYs
FROM   running_time
WHERE  session_status = 'start' AND stop_time IS NOT NULL;




-- note: couldn't figure out the proper window function.