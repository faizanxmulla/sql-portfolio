-- Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).
-- Return the result table in any order.


-- Solution 1: using subquery + LAG function

SELECT id AS Id
FROM   (SELECT id,
               temperature,
               Lag(temperature)
                 OVER(
                   ORDER BY recordDate) AS yesterday_temp
        FROM   weather) X
WHERE  temperature > yesterday_temp 



-- Solution 2: using CTE + LAG function

WITH yesterday
     AS (SELECT id,
                temperature,
                Lag(temperature)
                  OVER(
                    ORDER BY recordDate) AS yesterday_temp
         FROM   weather)

SELECT id AS Id
FROM   yesterday
WHERE  temperature > yesterday_temp; 
