-- working solution

SELECT DISTINCT commuter_id
       ,FLOOR(AVG(EXTRACT(EPOCH FROM end_dt - start_dt) / 60) OVER (PARTITION BY commuter_id)) as avg_commuter_time
       ,FLOOR(AVG(EXTRACT(EPOCH FROM end_dt - start_dt) / 60) OVER ()) avg_time
FROM   rides
WHERE  city = 'NY'



-- my solution: not working for avg_time column --> giving answer as 33 instead of 32.

WITH avg_commute AS (
    SELECT   commuter_id 
             ,AVG(EXTRACT(EPOCH FROM end_dt - start_dt) / 60) AS avg_commuter_time
    FROM     rides
    WHERE    city = 'NY'
    GROUP BY 1
)
SELECT commuter_id
       ,FLOOR(avg_commuter_time) AS avg_commuter_time
       ,FLOOR(AVG(avg_commuter_time) OVER ()) AS avg_time
FROM   avg_commute