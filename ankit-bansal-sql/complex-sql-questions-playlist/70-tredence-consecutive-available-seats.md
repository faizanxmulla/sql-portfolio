### Problem Statement

You are given a table named `cinema`. Several friends at a cinema ticket office would like to reserve consecutive available seats. 

Write a SQL query to find all sets of consecutive available seats, ordered by `seat_id`.

**Note**: 

- The seat_id is an auto-increment INT, & free is BOOL ('1' means free & '0' means occupied)

- Consecutive available seats are more than 2 (inclusive) seats consecutively available.


### Schema Setup

```sql
CREATE TABLE cinema (
    seat_id INT PRIMARY KEY,
    free int
);

DELETE FROM cinema;

INSERT INTO cinema (seat_id, free) VALUES 
(1, 1), (2, 0), (3, 1), (4, 1), (5, 1), (6, 0), (7, 1), (8, 1), (9, 0), (10, 1), (11, 0), (12, 1), (13, 0), (14, 1), (15, 1), (16, 0), (17, 1), (18, 1), (19, 1), (20, 1);
```

### Expected Output

consecutive_available_seats |
--|
3 |
4 |
5 |
7 |
8 |
14 |
15 |
17 |
18 |
19 |
20 |


### Solution Query

```sql
-- Solution 1: using ROW_NUMBER()

WITH grouped_seats as (
	SELECT seat_id, seat_id - ROW_NUMBER() OVER() as grp_id
	FROM   cinema
	WHERE  free=1
)
SELECT seat_id as consecutive_available_seats
FROM  (
	SELECT *, COUNT(*) OVER(PARTITION BY grp_id) as count
	FROM   grouped_seats
) X
WHERE count > 1



-- Solution 2: using LEAD and LAG functions

WITH prev_next_cte as (
	SELECT *, 
	       LAG(free) OVER(ORDER BY seat_id) as prev_free,
	       LEAD(free) OVER(ORDER BY seat_id) as next_free
	FROM   cinema
)
SELECT seat_id as consecutive_available_seats
FROM   prev_next_cte 
WHERE  free=1 and (prev_free=1 or next_free=1)



-- Solution 3: using JOIN and UNION

WITH CTE as (
	SELECT c1.seat_id as s1, c2.seat_id as s2
	FROM   cinema c1 JOIN cinema c2 ON c1.seat_id+1=c2.seat_id
	WHERE  c1.free=1 and c2.free=1
)
SELECT s1 as consecutive_available_seats
FROM   CTE
UNION 
SELECT s2
FROM   CTE
```



