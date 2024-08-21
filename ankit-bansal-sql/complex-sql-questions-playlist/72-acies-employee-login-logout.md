### Problem Statement

We have a swipe table which keeps track of the employee login and logout timings.

1. Find out the time employee person spent in office on a particular day (office hours = last logout time - first login time)

2. Find out how productive he was at office on a particular day. (He might have done many swipes per day. I need to find the actual time spent)

### Schema Setup

```sql
CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time TIMESTAMP
);

INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');
```

### Expected Output

For the first part (time spent in office):


employee_id | date       | office_hours
------------|------------|-------------
1           | 2024-07-23 | 08:00:00
2           | 2024-07-23 | 06:00:00
1           | 2024-07-24 | 04:00:00
2           | 2024-07-24 | 01:00:00


For the second part (actual time spent, considering multiple swipes):

employee_id | date       | productive_time
------------|------------|----------------
1           | 2024-07-23 | 08:00:00
2           | 2024-07-23 | 05:00:00
1           | 2024-07-24 | 04:00:00
2           | 2024-07-24 | 01:00:00


### Solution Query

```sql
-- For the first part (time spent in office):

SELECT   employee_id, 
         date(activity_time),
         MAX(activity_time) FILTER(WHERE activity_type='logout') - 
         MIN(activity_time) FILTER(WHERE activity_type='login') as office_hours
FROM     swipe
GROUP BY 1, 2
ORDER BY 2, 1



-- For the second part (actual time spent, considering multiple swipes):

WITH office_times as (
    SELECT employee_id,
           activity_type,
           activity_time as login_time, 
           LEAD(activity_time) OVER(PARTITION BY employee_id ORDER BY activity_time) as logout_time
    FROM   swipe
)
SELECT   employee_id, 
         date(login_time) as date,
         SUM(logout_time - login_time) as productive_hours
FROM     office_times
WHERE    activity_type='login'
GROUP BY 1, 2
```
