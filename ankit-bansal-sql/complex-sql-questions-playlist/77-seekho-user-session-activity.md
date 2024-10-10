### Problem Statement

Perform the following task: **Identify user sessions.** 

A session is defined as a sequence of activities by a user where the time difference between consecutive events is less than or equal to 30 minutes. 

If the time between two events exceeds 30 minutes, it's considered the start of a new session.

For each session, calculate the following `metrics`:

   - `session_id` (a unique identifier for each session).

   - `session_start_time` (the timestamp of the first event in the session).

   - `session_end_time` (the timestamp of the last event in the session).

   - `session_duration` (the difference between session_end_time and session_start_time).

   - `event_count` (the number of events in the session). 



### Schema Setup

```sql
CREATE TABLE events (
    userid INT,
    event_type VARCHAR(20),
    event_time DATETIME
);

INSERT INTO events (userid, event_type, event_time) VALUES 
(1, 'click', '2023-09-10 09:00:00'),
(1, 'click', '2023-09-10 10:00:00'),
(1, 'scroll', '2023-09-10 10:20:00'),
(1, 'click', '2023-09-10 10:50:00'),
(1, 'scroll', '2023-09-10 11:40:00'),
(1, 'click', '2023-09-10 12:40:00'),
(1, 'scroll', '2023-09-10 12:50:00'),
(2, 'click', '2023-09-10 09:00:00'),
(2, 'scroll', '2023-09-10 09:20:00'),
(2, 'click', '2023-09-10 10:30:00');
```


### Expected Output

| userid | session_id | session_start_time      | session_end_time        | session_duration | event_count |
|--------|------------|-------------------------|-------------------------|------------------|-------------|
| 1      | 1          | 2023-09-10 09:00:00.000 | 2023-09-10 09:00:00.000 | 0                | 1           |
| 1      | 2          | 2023-09-10 10:00:00.000 | 2023-09-10 10:50:00.000 | 50               | 3           |
| 1      | 3          | 2023-09-10 11:40:00.000 | 2023-09-10 11:40:00.000 | 0                | 1           |
| 1      | 4          | 2023-09-10 12:40:00.000 | 2023-09-10 12:50:00.000 | 10               | 2           |
| 2      | 1          | 2023-09-10 09:00:00.000 | 2023-09-10 09:20:00.000 | 20               | 2           |
| 2      | 2          | 2023-09-10 10:30:00.000 | 2023-09-10 10:30:00.000 | 0                | 1           |



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