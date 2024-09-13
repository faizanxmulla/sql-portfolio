### Problem Statement

Write a SQL query that, given a list of integers, returns each integer repeated as many times as its value. 

For example, if the input is 1, 2, 3, the output should be 1, 2, 2, 3, 3, 3.

**Note**: provide solution w/o using recursive CTE.


### Schema Setup

```sql
CREATE TABLE numbers (n INT);

INSERT INTO numbers (n) VALUES (1), (2), (3)

-- for testing non-consecutive sequences
INSERT INTO numbers (n) VALUES (6)
```

### Expected Output

num_repetition |
--|
1 |
2 |
2 |
3 |
3 |
3 |


### Solution Query

```sql
-- Solution 1: w/ recursive CTE

WITH RECURSIVE CTE as (
	SELECT n, 1 as counter 
	FROM   numbers
	UNION ALL
	SELECT n, counter+1
	FROM   CTE 
	WHERE  counter+1 <= n
)
SELECT   n
FROM     CTE
ORDER BY 1


-- Solution 2: w/o recursive CTE (in case of consecutive sequences) // using CROSS JOIN

SELECT   n1.n
FROM     numbers n1 JOIN numbers n2 ON n1.n >= n2.n
ORDER BY 1


-- Solution 3: in case of non-consecutive sequences // using recursive CTE + CROSS JOIN

WITH RECURSIVE CTE as (
	SELECT MAX(n) as n
	FROM   numbers
	UNION ALL
	SELECT n-1
	FROM   CTE 
	WHERE  n-1 >= 1
)
SELECT   n1.n
FROM     numbers n1 JOIN CTE n2 ON n1.n >= n2.n
ORDER BY 1
```