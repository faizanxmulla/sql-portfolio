### Problem Statement

We have a table that stores data from multiple sections. Every section has 3 numbers. We need to find the top 4 numbers from any 2 sections (2 numbers each) where the sum of the numbers is the maximum. 

In this case, we will choose section B where we have 19 (10+9), and then we need to choose either section C or D. Since both have a sum of 18, we prioritize D because it contains a 10, which is larger than 9 from section C.

### Schema Setup

```sql
CREATE TABLE section_data (
  section VARCHAR(1),
  number INT
);

INSERT INTO section_data VALUES
('A', 5),
('A', 7),
('A', 10),
('B', 7),
('B', 9),
('B', 10),
('C', 9),
('C', 7),
('C', 9),
('D', 10),
('D', 3),
('D', 8);
```

### Expected Output

| section | number |
|---------|--------|
| B       | 10     |
| B       | 9      |
| D       | 10     |
| D       | 8      |

### Solution Query

```sql
WITH ranked_numbers as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY section ORDER BY number desc) as rn
    FROM   section_data
),
section_sums as (
    SELECT   section, SUM(number) as section_sum, MAX(number) as section_max
    FROM     ranked_numbers
    WHERE    rn <= 2
    GROUP BY 1
)
SELECT section, number
FROM   ranked_numbers
WHERE  section IN (
    SELECT   section
    FROM     section_sums
    ORDER BY section_sum DESC, section_max DESC
    LIMIT    2
) and rn <= 2



-- my initial approach: 

WITH ranked_numbers as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY section ORDER BY number desc) as rn
    FROM   section_data
),
section_sum_cte as (
    SELECT *, SUM(number) OVER(PARTITION BY section) as section_sum
    FROM   ranked_numbers
    WHERE  rn <= 2
)
SELECT   section, number
FROM     section_sum_cte
ORDER BY section_sum desc, number desc
```
