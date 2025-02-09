WITH combined_fb_data as (
    SELECT *
    FROM   fb_eu_energy
    UNION 
    SELECT *
    FROM   fb_asia_energy
    UNION
    SELECT *
    FROM   fb_na_energy
)
,ranked_dates as (
    SELECT   date, 
             SUM(consumption) as total_consumption,
             RANK() OVER(ORDER BY SUM(consumption) desc) as rn
    FROM     combined_fb_data
    GROUP BY date
)
SELECT date, total_consumption
FROM   ranked_dates
WHERE  rn=1