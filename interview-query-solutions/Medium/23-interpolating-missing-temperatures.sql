WITH CTE as (
    SELECT date,
           city,
           temperature, 
           LEAD(temperature) OVER (PARTITION BY city ORDER BY date) AS next_temp,
           LAG(temperature) OVER (PARTITION BY city ORDER BY date) AS prev_temp
    FROM   temperature_data
)
SELECT date,
       city,
       CASE 
            WHEN temperature IS NOT NULL THEN temperature
            ELSE prev_temp + (next_temp - prev_temp) / 2
       END AS temperature
FROM   CTE



-- my initial attempt : 

WITH CTE as (
    SELECT date,
           city,
           temperature, 
           LEAD(temperature) OVER(PARTITION BY city ORDER BY date) as next_temp,
           LEAD(temperature, 2) OVER(PARTITION BY city ORDER BY date) - temperature as linear_value
    FROM   temperature_data
)
SELECT date,
       city, 
       COALESCE(temperature, temperature + linear_value/2) as temperature
FROM   CTE



   
-- NOTE: 

-- couldn't solve entirely on my own
-- got the idea but couldn't execute it completely.