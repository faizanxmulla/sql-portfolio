-- Solution 1: using RECURSIVE CTE

WITH RECURSIVE CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY start_date) as row_num
    FROM projects
)
,rec_cte AS (
    SELECT *, 1 AS flag
    FROM   CTE
    WHERE  row_num = 1
    UNION ALL
    SELECT c.*,
           CASE 
               WHEN c.start_date <= rc.end_date + INTERVAL '1 DAY'
               THEN rc.flag 
               ELSE rc.flag + 1 
           END AS flag
    FROM   rec_cte rc JOIN CTE c 
    ON     rc.employee_id = c.employee_id
           and rc.row_num + 1 = c.row_num
)
,merged_cte as (
    SELECT   employee_id, 
             MIN(start_date) as start_date, 
             MAX(end_date) as end_date
    FROM     rec_cte
    GROUP BY employee_id, flag
)
SELECT   employee_id, 
         SUM(end_date - start_date + 1) as unique_days_worked
FROM     merged_cte
GROUP BY employee_id
ORDER BY employee_id




-- Solution 2: using GENERATE_SERIES()

WITH dates as (
    SELECT employee_id,
           generate_series(start_date, end_date, INTERVAL'1 day')::date as unique_calendar_days
    FROM   projects
)
SELECT   employee_id,
         COUNT(DISTINCT unique_calendar_days) as unique_days_worked
FROM     dates
GROUP BY employee_id
ORDER BY employee_id



-- NOTE: 

-- almost the same question in Leetcode Hard - 2494
-- link: https://leetcode.com/problems/merge-overlapping-events-in-the-same-hall/description/