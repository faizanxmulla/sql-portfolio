### Problem Statement

Write a query to print total rides and profit rides for each driver. A profit ride is defined as a ride where the end location of the current ride is the same as the start location of the next ride for that driver.

### Schema Setup

```sql
CREATE TABLE drivers (
    id VARCHAR(10),
    start_time TIME,
    end_time TIME,
    start_loc CHAR(1),
    end_loc CHAR(1)
);

INSERT INTO drivers VALUES
('dri_1', '09:00:00', '09:30:00', 'a', 'b'),
('dri_1', '09:30:00', '10:30:00', 'b', 'c'),
('dri_1', '11:00:00', '11:30:00', 'd', 'e'),
('dri_1', '12:00:00', '12:30:00', 'f', 'g'),
('dri_1', '13:30:00', '14:30:00', 'c', 'h'),
('dri_2', '12:15:00', '12:30:00', 'f', 'g'),
('dri_2', '13:30:00', '14:30:00', 'c', 'h');
```

### Expected Output

| id    | total_rides | profit_rides |
|-------|-------------|--------------|
| dri_1 | 5           | 1            |
| dri_2 | 2           | 0            |

### Solution Query

```sql
-- Solution 1: using LEAD() window function // also my attempt

WITH next_rides as (
    SELECT *, LEAD(start_loc) OVER(PARTITION BY id ORDER BY start_time) as next_start_loc
    FROM   drivers
)
SELECT   id, 
         COUNT(*) as total_rides, 
         COUNT(*) FILTER(WHERE end_loc=next_start_loc) as profit_rides
FROM     next_rides
GROUP BY 1


-- Solution 2: using SELF join

WITH rides as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY start_time) as rn
    FROM   drivers
)
SELECT   r1.id, 
         COUNT(*) AS total_rides, 
         COUNT(r2.id) AS profit_rides
FROM     rides r1 LEFT JOIN rides r2 ON r1.id=r2.id and r1.end_loc=r2.start_loc and r2.rn=r1.rn+1
GROUP BY 1
```