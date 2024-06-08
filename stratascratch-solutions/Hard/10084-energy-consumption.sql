WITH combined_data AS (
    SELECT * 
    FROM   fb_eu_energy
    UNION ALL
    SELECT * 
    FROM   fb_na_energy
    UNION ALL
    SELECT * 
    FROM   fb_asia_energy),
consumption_cte AS (
     SELECT   date, SUM(consumption) AS total
     FROM     combined_data
     GROUP BY 1
)
SELECT date,
       SUM(total) OVER(ORDER BY date) AS cum_sum,
       ROUND(100.0 * SUM(total) OVER(ORDER BY date) / (SELECT SUM(total) FROM consumption_cte)) AS cum_percentage
FROM   consumption_cte