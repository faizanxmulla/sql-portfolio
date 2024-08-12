### Problem Statement

Write an SQL query to find the missing quarter for each store.

### Schema Setup

```sql
CREATE TABLE stores (
    store_id varchar(10),
    quarter varchar(10),
    amount int);

INSERT INTO stores (store_id, quarter, amount) VALUES 
('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);
```

### Expected Output

store_id |	missing_quarter |
--|--|
S1 |	Q3 |
S2 |	Q2 |
S3 |	Q4 |

### Solution Query

```sql
-- Solution 1: nice, intuitive solution

WITH CTE AS (
    SELECT   store_id, SUM(RIGHT(quarter, 1)::INT) AS store_no
    FROM     stores
    GROUP BY 1
)
SELECT store_id, CONCAT('Q', 10-store_no) AS missing_quarter
FROM   CTE



-- Solution 2: using RECURSICE CTE.

WITH RECURSIVE CTE AS (
    SELECT DISTINCT store_id, 1 as quarter_no
    FROM   stores
    UNION ALL
    SELECT store_id, quarter_no+1 as quarter_no
    FROM   CTE 
    WHERE  quarter_no < 4
),
all_quarters AS (
    SELECT   store_id, CONCAT('Q', quarter_no) AS quarter
    FROM     CTE
    ORDER BY 1, 2
)
SELECT store_id, quarter as missing_quarter
FROM   all_quarters LEFT JOIN stores USING(store_id, quarter)
WHERE  amount IS NULL



-- Solution 3: using CROSS JOIN. 

WITH all_quarters AS (
    SELECT   DISTINCT s1.store_id, s2.quarter
    FROM     stores s1, stores s2
    ORDER BY 1, 2
)
SELECT store_id, quarter as missing_quarter
FROM   all_quarters LEFT JOIN stores USING(store_id, quarter)
WHERE  amount IS NULL
```