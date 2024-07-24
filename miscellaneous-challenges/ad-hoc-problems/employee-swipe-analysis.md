### Problem Statement

There is a swipe table which keeps track of the employee login and logout timings. The task is to:

1. Find out the time employee spent in office on a particular day (office hours = last logout time - first login time)

2. Find out how much productive he was at office on a particular day. (He might have done many swipes per day. I need to find the actual time spent at office)


### Schema setup

```sql
DROP TABLE IF EXISTS swipe_table;
CREATE TABLE swipe_table (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time TIMESTAMP
);

INSERT INTO swipe_table (employee_id, activity_type, activity_time) VALUES 
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');
```


### Expected Output

| employee_id | activity_day | total_hours | productive_hours |
|-------------|--------------|-------------|------------------|
| 1           | 2024-07-23   | 9           | 8                |
| 2           | 2024-07-23   | 6           | 5                |
| 1           | 2024-07-24   | 4           | 4                |
| 2           | 2024-07-24   | 1           | 1                |


### Solution Query

```SQL
WITH daily_swipes AS (
	SELECT   employee_id,
		     DATE(activity_time) AS activity_day,
		     MIN(CASE WHEN activity_type = 'login' THEN activity_time END) AS first_login,
		     MAX(CASE WHEN activity_type = 'logout' THEN activity_time END) AS last_logout
	FROM     swipe_table
	GROUP BY 1, 2
),
time_differences AS (
	SELECT employee_id,
		   DATE(activity_time) AS activity_day,
		   activity_time,
		   LEAD(activity_time) OVER (PARTITION BY employee_id, DATE(activity_time) ORDER BY activity_time) AS next_activity_time,
		   activity_type
	FROM   swipe_table
),
productive_hours AS (
	SELECT   employee_id,
		   	 DATE(activity_time) AS activity_day,  
		     SUM(CASE 
					  WHEN activity_type = 'login' 
					  THEN EXTRACT(HOUR FROM (next_activity_time - activity_time))
				  ELSE 0
		     END) AS productive_hours  
	FROM     time_differences
	GROUP BY 1, 2
)
SELECT   ds.employee_id,
         ds.activity_day,
         EXTRACT(HOUR FROM (last_logout - first_login)) AS total_hours,
         ph.productive_hours AS productive_hours
FROM     daily_swipes ds JOIN productive_hours ph USING(employee_id, activity_day)
ORDER BY 2, 1



-- NOTE: can be made short by reducing the number of CTE's but current presented solution is very to understand.
```

