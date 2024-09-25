### Problem Statement

Write a SQL query to get the max and min populated cities of each state.



### Schema Setup

```sql
CREATE TABLE city_population (
    state VARCHAR(50),
    city VARCHAR(50),
    population INT
);

INSERT INTO city_population (state, city, population) VALUES 
('haryana', 'ambala', 100),
('haryana', 'panipat', 200),
('haryana', 'gurgaon', 300),
('punjab', 'amritsar', 150),
('punjab', 'ludhiana', 400),
('punjab', 'jalandhar', 250),
('maharashtra', 'mumbai', 1000),
('maharashtra', 'pune', 600),
('maharashtra', 'nagpur', 300),
('karnataka', 'bangalore', 900),
('karnataka', 'mysore', 400),
('karnataka', 'mangalore', 200);
```


### Expected Output

| state       | max_populated_city  | min_populated_city |
|-------------|---------------------|--------------------|
| haryana     | gurgaon             | ambala             |
| karnataka   | bangalore           | mangalore          |
| maharashtra | mumbai              | nagpur             |
| punjab      | ludhiana            | amritsar           |



### Solution

```sql
WITH ranked_cities as (
	SELECT *, 
           RANK() OVER(PARTITION BY state ORDER BY population desc) as max_rn, 
           RANK() OVER(PARTITION BY state ORDER BY population) as min_rn
	FROM   city_population
)
SELECT   state, 
         MAX(city) FILTER(WHERE max_rn=1) as max_populated_city, 
         MAX(city) FILTER(WHERE min_rn=1) as min_populated_city
FROM     ranked_cities 
WHERE    max_rn=1 or min_rn=1
GROUP BY 1


-- NOTE: 

-- can be solved by many similar approaches: 

-- 1. ROW_NUMBER() instead of RANK()
-- 2. MAX() and MIN() instead of RANK()
-- 3. MAX(CASE WHEN ...) instead of MAX(FILTER WHERE ...)
```