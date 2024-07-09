### Problem Statement

Generate a report to showcase the period of presence and absence of each employee as shown in expected output.

### Schema setup

```sql
CREATE TABLE attendance (
    employee VARCHAR(100),
    dates DATE,
    status VARCHAR(10)
);

INSERT INTO attendance (employee, dates, status) VALUES
('A1', '2024-01-01', 'PRESENT'),
('A1', '2024-01-02', 'PRESENT'),
('A1', '2024-01-03', 'PRESENT'),
('A1', '2024-01-04', 'ABSENT'),
('A1', '2024-01-05', 'PRESENT'),
('A1', '2024-01-06', 'PRESENT'),
('A1', '2024-01-07', 'ABSENT'),
('A1', '2024-01-08', 'ABSENT'),
('A1', '2024-01-09', 'ABSENT'),
('A1', '2024-01-10', 'PRESENT'),
('A2', '2024-01-06', 'PRESENT'),
('A2', '2024-01-07', 'PRESENT'),
('A2', '2024-01-08', 'ABSENT'),
('A2', '2024-01-09', 'PRESENT'),
('A2', '2024-01-10', 'ABSENT');
```

### Solution Query

```sql
-- Solution 1: using MIN-MAX 

WITH attendance_records AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY employee ORDER BY dates) AS rn
    FROM   attendance
),
flagged_records AS (
    SELECT *, (rn - ROW_NUMBER() OVER(PARTITION BY employee, status ORDER BY dates)) AS flag
    FROM attendance_records
)
SELECT   employee, status, MIN(dates) AS from_date, MAX(dates) AS to_date
FROM     flagged_records
GROUP BY 1, 2, flag
ORDER BY 1, 3


-- Solution 2: using FIRST_VALUE() & LAST_VALUE()

WITH attendance_records AS (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY employee ORDER BY employee, dates) AS rn
	FROM attendance
),
present_records AS (
	SELECT *, (rn - ROW_NUMBER() OVER(PARTITION BY employee ORDER BY employee, dates)) as flag
	FROM   attendance_records
	WHERE  status='PRESENT'
),
absent_records AS (
	SELECT *, (rn - ROW_NUMBER() OVER(PARTITION BY employee ORDER BY employee, dates)) as flag
	FROM   attendance_records
	WHERE  status='ABSENT'
)
SELECT employee,
	   status,
	   FIRST_VALUE(dates) OVER(PARTITION BY employee, flag ORDER BY employee, dates) AS from_date,   
       LAST_VALUE(dates) OVER(PARTITION BY employee, flag ORDER BY employee, dates
	                          RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS to_date    
FROM   present_records   
UNION
SELECT employee, 
	   status,
	   FIRST_VALUE(dates) OVER(PARTITION BY employee, flag ORDER BY employee, dates) AS from_date,   
       LAST_VALUE(dates) OVER(PARTITION BY employee, flag ORDER BY employee, dates
	                          RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS to_date    
FROM   absent_records 
ORDER BY 1, from_date
```