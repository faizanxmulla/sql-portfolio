### Problem Statement

Given a table with event times and statuses, find the time intervals where the status changes from 'on' to 'off' and count the number of 'on' events within each interval.

*NOTE :* similar to [10 - Report Contiguous Dates](https://github.com/faizanxmulla/sql-portfolio/blob/main/ankit-bansal-sql/complex-sql-questions-playlist/10-report-contiguous-dates.md)


### Schema Setup

```sql
CREATE TABLE event_status (
    event_time TIME,
    status VARCHAR(3)
);

INSERT INTO event_status VALUES 
('10:01', 'on'),
('10:02', 'on'),
('10:03', 'on'),
('10:04', 'off'),
('10:07', 'on'),
('10:08', 'on'),
('10:09', 'off'),
('10:11', 'on'),
('10:12', 'off');
```

### Expected Output

| login | logout | cnt |
|-------|--------|-----|
| 10:01 | 10:04  | 3   |
| 10:07 | 10:09  | 2   |
| 10:11 | 10:12  | 1   |

### Solution Query

```sql
WITH timestamps_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(ORDER BY event_time) -
           ROW_NUMBER() OVER(PARTITION BY status ORDER BY event_time) AS bins
    FROM   event_status
)
SELECT   MIN(event_time) as login, 
         MAX(event_time) as logout, 
         COUNT(status) FILTER(WHERE status='on') as cnt
FROM     timestamps_cte 
GROUP BY bins
HAVING   COUNT(status) FILTER(WHERE status = 'on') > 0 
ORDER BY 1
``` 


