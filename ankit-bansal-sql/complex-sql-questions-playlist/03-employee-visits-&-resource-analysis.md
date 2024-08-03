### Problem statement 

Summarize the data with the name of the employee, total number of visits by each employee, most visited floor by employee and the resources used by them.

### Schema Setup

```sql
CREATE TABLE entries (
    name VARCHAR(20),
    address VARCHAR(20),
    email VARCHAR(20),
    floor INT,
    resources VARCHAR(10)
);

INSERT INTO entries VALUES 
('A', 'Bangalore', 'A@gmail.com', 1, 'CPU'),
('A', 'Bangalore', 'A1@gmail.com', 1, 'CPU'),
('A', 'Bangalore', 'A2@gmail.com', 2, 'DESKTOP'),
('B', 'Bangalore', 'B@gmail.com', 2, 'DESKTOP'),
('B', 'Bangalore', 'B1@gmail.com', 2, 'DESKTOP'),
('B', 'Bangalore', 'B2@gmail.com', 1, 'MONITOR');
```

### Expected Output

name |	total_visits |	floor |	all_resources |
--|--|--|--|
A |	3 |	1 |	CPU, DESKTOP |
B |	3 |	2 |	DESKTOP, MONITOR |


### Solution Query

```sql
WITH total_visits_cte AS (
	SELECT   name, 
			 COUNT(*) AS total_visits,
			 STRING_AGG(DISTINCT resources, ', ') AS all_resources
	FROM     entries
	GROUP BY 1
	ORDER BY 1
),
floor_visits_cte AS (
	SELECT   name, 
			 floor, 
			 COUNT(*) AS floor_visits,
			 RANK() OVER(PARTITION BY name ORDER BY COUNT(*) DESC) AS rn
	FROM     entries
	GROUP BY 1, 2
	ORDER BY 1, 2
)
SELECT t.name, total_visits, floor, all_resources
FROM   total_visits_cte t JOIN floor_visits_cte f USING(name)
WHERE  rn=1
```
