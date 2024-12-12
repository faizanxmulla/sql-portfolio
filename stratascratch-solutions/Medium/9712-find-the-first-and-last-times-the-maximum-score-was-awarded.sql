-- my solution: using FIRST_VALUE window function
-- too complicated for simple question


WITH CTE as (
    SELECT FIRST_VALUE(activity_date) OVER(ORDER BY activity_date) as first_value,
           FIRST_VALUE(activity_date) OVER(ORDER BY activity_date desc) as last_value
    FROM   los_angeles_restaurant_health_inspections
    WHERE  score = (SELECT MAX(score) 
                    FROM   los_angeles_restaurant_health_inspections)
)
SELECT DISTINCT first_value, last_value
FROM   CTE



-- Solution 2: using MIN and MAX
-- much easier approach than mine


SELECT MIN(activity_date) AS first_value,
       MAX(activity_date) AS last_value
FROM   los_angeles_restaurant_health_inspections
WHERE  score = (SELECT MAX(score) 
                FROM los_angeles_restaurant_health_inspections)