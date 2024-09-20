## Problem 1/2

### Problem Statement

Find the origin and the final destination for each city.

### Schema Setup

```sql
CREATE TABLE flights (
    cid VARCHAR(512),
    flight_id VARCHAR(512),
    origin VARCHAR(512),
    destination VARCHAR(512)
);

INSERT INTO flights VALUES 
('1', 'f1', 'Del', 'Hyd'),
('1', 'f2', 'Hyd', 'Blr'),
('2', 'f3', 'Mum', 'Agra'),
('2', 'f4', 'Agra', 'Kol');
```


### Expected Output

city_id | origin | destination |
--|--|--|
1 | Del | Blr |
2 | Mum | Kol |

### Solution Query

```sql
-- Solution 1: using INNER JOIN.

SELECT o.cid, o.origin, d.destination
FROM   flights o JOIN flights d ON o.destination=d.origin



-- Solution 2: using ROW_NUMBER() and MAX()

WITH ranked_flights as (
    SELECT cid, 
           origin, 
           destination, 
           ROW_NUMBER() OVER(PARTITION BY cid ORDER BY flight_id) AS flight_start,
           ROW_NUMBER() OVER(PARTITION BY cid ORDER BY flight_id desc) AS flight_end
    FROM   flights
)
SELECT   cid, 
         MAX(CASE WHEN flight_start = 1 THEN origin END) AS origin, 
         MAX(CASE WHEN flight_end = 1 THEN destination END) AS destination
FROM     ranked_flights
GROUP BY 1



-- my attempt: 

WITH cities_cte as (
    SELECT cid, origin as city_name, 'origin' as city_type
    FROM   flights
    UNION ALL
    SELECT cid, destination as city_name, 'destination' as city_type
    FROM   flights
    ORDER BY 1
),
unique_cities as (
    SELECT *, COUNT(*) OVER(PARTITION BY cid, city_name) as count
    FROM   cities_cte
)
SELECT   cid, 
         MAX(city_name) FILTER(WHERE city_type='origin' and count=1) as origin, 
         MAX(city_name) FILTER(WHERE city_type='destination' and count=1) as destination
FROM     unique_cities
GROUP BY 1
```

---
---


## Problem 2/2

### Problem Statement

Find the count of new customer added in each month.


### Schema Setup

```sql
CREATE TABLE sales (
    order_date date,
    customer VARCHAR(512),
    quantity INT
);

INSERT INTO sales VALUES 
('2021-01-01', 'C1', '20'),
('2021-01-01', 'C2', '30'),
('2021-02-01', 'C1', '10'),
('2021-02-01', 'C3', '15'),
('2021-03-01', 'C5', '19'),
('2021-03-01', 'C4', '10'),
('2021-04-01', 'C3', '13'),
('2021-04-01', 'C5', '15'),
('2021-04-01', 'C6', '10');
```


### Expected Output

month | new_customer_count |
--|--|
Jan-21 | 2 |
Feb-21 | 1 |
Mar-21 | 2 |
Apr-21 | 1 |


### Solution Query

```sql
WITH CTE as (
    SELECT order_date, 
           customer, 
           ROW_NUMBER() OVER(PARTITION BY customer ORDER BY order_date) as rn
    FROM   sales
)
SELECT   TO_CHAR(order_date, 'Mon-YY') AS month, 
         COUNT(customer) AS new_customer_count
FROM     CTE
WHERE    rn=1
GROUP BY 1
ORDER BY MIN(order_date)
```