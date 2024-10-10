![image](https://github.com/user-attachments/assets/fd18ed8a-a53d-44e6-8c52-69ac4b3ce90b)



### Solution Query

```sql
WITH lag_times_cte AS (
    SELECT *,
           LAG(event_time, 1, event_time) OVER(PARTITION BY userid ORDER BY event_time) AS prev_event_time
    FROM   events
),
session_bins_cte AS (
    SELECT *,
           SUM(CASE WHEN event_time - prev_event_time <= INTERVAL '30 minutes' THEN 0 ELSE 1 END) OVER(PARTITION BY userid ORDER BY event_time) AS bins
    FROM   lag_times_cte
)
SELECT   userid, 
         bins+1 as session_id,
         MIN(event_time) AS session_start_time,
         MAX(event_time) AS session_end_time,
         ROUND(EXTRACT(EPOCH FROM (MAX(event_time) - MIN(event_time))) / 60) AS session_duration,
         COUNT(event_type) AS event_count
FROM     session_bins_cte
GROUP BY 1, bins
ORDER BY 1, bins
```


#### Question Link: [Namaste SQL - Q118/Hard](https://www.namastesql.com/coding-problem/118-user-session-activity)