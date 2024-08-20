### Problem Statement

Write a SQL query to populate category values to the last not null value.

### Schema Setup

```sql
CREATE TABLE brands (
    category VARCHAR(20),
    brand_name VARCHAR(20)
);

INSERT INTO brands VALUES
('chocolates', '5-star'),
(NULL, 'dairy milk'),
(NULL, 'perk'),
(NULL, 'eclair'),
('Biscuits', 'britannia'),
(NULL, 'good day'),
(NULL, 'boost');
```

### Expected Output

category |	brand_name |
--|--|
chocolates |	5-star |
chocolates |	dairy milk |
chocolates |	perk |
chocolates |	eclair |
Biscuits |	britannia |
Biscuits |	good day |
Biscuits |	boost |


### Solution Query

```sql
-- Solution 1: using ROW_NUMBER() and LEAD()

WITH generate_ids AS (
    SELECT *, ROW_NUMBER() OVER() as id
    FROM   brands
),
next_ids AS (
    SELECT *, LEAD(id, 1, 999999) OVER(ORDER BY id) as category_change_id
    FROM   generate_ids
    WHERE  category IS NOT NULL
)
SELECT ni.category, gi.brand_name
FROM   generate_ids gi JOIN next_ids ni ON gi.id >= ni.id AND gi.id <= ni.category_change_id - 1



-- Solution 2: using rows between

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER() AS id 
    FROM   brands
)
SELECT MIN(category) OVER (
           ORDER BY id 
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS category, 
       brand_name
FROM   CTE
```