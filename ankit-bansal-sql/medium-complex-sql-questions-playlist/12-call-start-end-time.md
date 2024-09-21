### Problem Statement

Write a query to get `start time` and the `end time` of each call from the below 2 tables. 

Also create a column of call duration in minutes. 

**NOTE:** Please do take into account there will be multiple calls from phone number and each entry in `start` table has a corresponding entry in the `end` table.


### Schema Setup

```sql
CREATE TABLE call_start_logs(
    phone_number VARCHAR(10),
    start_time TIMESTAMP
);

CREATE TABLE call_end_logs(
    phone_number VARCHAR(10),
    end_time TIMESTAMP
);


INSERT INTO call_start_logs VALUES
('PN1', '2022-01-01 10:20:00'),
('PN1', '2022-01-01 16:25:00'),
('PN2', '2022-01-01 12:30:00'),
('PN3', '2022-01-02 10:00:00'),
('PN3', '2022-01-02 12:30:00'),
('PN3', '2022-01-03 09:20:00');

INSERT INTO call_end_logs VALUES
('PN1', '2022-01-01 10:45:00'),
('PN1', '2022-01-01 17:05:00'),
('PN2', '2022-01-01 12:55:00'),
('PN3', '2022-01-02 10:20:00'),
('PN3', '2022-01-02 12:50:00'),
('PN3', '2022-01-03 09:40:00');
```


### Expected Output

phone_number |	start_time |	end_time |	call_minutes |
--|--|--|--|
PN1 |	2022-01-01T10:20:00.000 |	2022-01-01T10:45:00.000 |	25.00 |
PN1 |	2022-01-01T16:25:00.000 |	2022-01-01T17:05:00.000 |	40.00 |
PN2 |	2022-01-01T12:30:00.000 |	2022-01-01T12:55:00.000 |	25.00 |
PN3 |	2022-01-02T10:00:00.000 |	2022-01-02T10:20:00.000 |	20.00 |
PN3 |	2022-01-02T12:30:00.000 |	2022-01-02T12:50:00.000 |	20.00 |
PN3 |	2022-01-03T09:20:00.000 |	2022-01-03T09:40:00.000 |	20.00 |


### Solution Query

```sql
-- Solution 1: using ROW_NUMBER() & JOIN // also my approach

WITH start_logs_cte as (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY phone_number ORDER BY start_time) as start_rn
    FROM   call_start_logs
)
, end_logs_cte as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY phone_number ORDER BY end_time) as end_rn
    FROM   call_end_logs
)
SELECT   sl.phone_number, 
         start_time, 
         end_time, 
         ROUND(EXTRACT(EPOCH FROM AGE(end_time, start_time)) / 60, 2) as call_minutes
FROM     start_logs_cte sl JOIN end_logs_cte el ON sl.start_rn=el.end_rn and sl.phone_number=el.phone_number
ORDER BY 1, 2


-- Solution 2: using UNION ALL

WITH CTE as (
    SELECT phone_number,
           start_time as call_time, 
           ROW_NUMBER() OVER(PARTITION BY phone_number ORDER BY start_time) as rn
    FROM   call_start_logs
    UNION ALL
    SELECT phone_number,
           end_time as call_time, 
           ROW_NUMBER() OVER(PARTITION BY phone_number ORDER BY end_time) as rn
    FROM   call_end_logs
)
SELECT   phone_number,
         MIN(call_time) as start_time,
         MAX(call_time) as end_time,
         ROUND(EXTRACT(EPOCH FROM AGE(MAX(call_time), MIN(call_time))) / 60, 2) as call_minutes
FROM     CTE
GROUP BY phone_number, rn
ORDER BY 1, 2
```