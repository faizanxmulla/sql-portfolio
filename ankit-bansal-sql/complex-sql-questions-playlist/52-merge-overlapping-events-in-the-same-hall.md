### Problem Statement | [Leetcode - Hard 2494](https://leetcode.com/problems/merge-overlapping-events-in-the-same-hall/description/)


Write a SQL query to merge overlapping events for each hall, combining the date ranges for events that overlap or are adjacent.

### Schema Setup

```sql
CREATE TABLE hall_events (
    hall_id INT,
    start_date DATE,
    end_date DATE
);

INSERT INTO hall_events (hall_id, start_date, end_date) VALUES
(1, '2023-01-13', '2023-01-14'),
(1, '2023-01-14', '2023-01-17'),
(1, '2023-01-15', '2023-01-17'),
(1, '2023-01-18', '2023-01-25'),
(2, '2022-12-09', '2022-12-23'),
(2, '2022-12-13', '2022-12-17'),
(3, '2022-12-01', '2023-01-30');
```

### Expected Output

| hall_id | start_date | end_date   |
|---------|------------|------------|
| 1       | 2023-01-13 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 3       | 2022-12-01 | 2023-01-30 |



### Solution Query

```sql
WITH RECURSIVE cte as (
    SELECT *, ROW_NUMBER() OVER(ORDER BY hall_id, start_date) as event_id
    FROM   hall_events
),
rec_cte as (
    SELECT *, 1 as flag
    FROM   cte
    WHERE  event_id=1
    UNION ALL
    SELECT c.*,
	       CASE WHEN rc.hall_id=c.hall_id AND (rc.start_date BETWEEN c.start_date and c.end_date OR c.start_date BETWEEN rc.start_date and rc.end_date) 
				THEN 0 ELSE 1 
	       END + flag as flag      
    FROM   rec_cte rc JOIN cte c ON rc.event_id+1 = c.event_id
)  
SELECT   hall_id, MIN(start_date) as start_date, MAX(end_date) as end_date
FROM     rec_cte 
GROUP BY 1, flag



-- my first attempt

WITH first_last_dates as (
    SELECT   hall_id, MIN(start_date) as first_date, MAX(end_date) as last_date
    FROM     hall_events
    GROUP BY 1
    ORDER BY 1
)
SELECT *
FROM   hall_events he LEFT JOIN first_last_dates fl 
ON     he.hall_id=fl.hall_id 
       and start_date BETWEEN first_date and end_date


-- NOTE: should have thought on own to use RECURSIVE CTE.
```

