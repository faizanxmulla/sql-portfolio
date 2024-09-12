### Problem Statement

Remove duplicate rows from the city_distance table where source, destination, and distance are the same, keeping only the first occurrence. 

Provide three different SQL solutions, with the first two not guaranteeing that the first row will come first, and the third solution ensuring the first row is preserved.

### Schema Setup

```sql
CREATE TABLE city_distance (
    distance INT,
    source VARCHAR(50),
    destination VARCHAR(50)
);

INSERT INTO city_distance (distance, source, destination) VALUES
(100, 'New Delhi', 'Panipat'),
(200, 'Ambala', 'New Delhi'),
(150, 'Bangalore', 'Mysore'),
(200, 'Mysore', 'Bangalore'),
(250, 'Mumbai', 'Pune'),
(250, 'Pune', 'Mumbai'),
(2500, 'Chennai', 'Bhopal'),
(2500, 'Bhopal', 'Chennai'),
(60, 'Tirupati', 'Tirumala'),
(80, 'Tirumala', 'Tirupati');
```

### Solution Query

```sql
-- Solution 1 (Using GROUP BY)

SELECT   MIN(distance) as distance, source, destination
FROM     city_distance
GROUP BY source, destination, distance;
```


```sql
-- Solution 2 (Using DISTINCT ON)

SELECT DISTINCT ON (distance, source, destination) distance, source, destination
FROM   city_distance;
```


```sql
-- Solution 3 (Using ROW_NUMBER to preserve first occurrence)

WITH ranked_rows AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY distance, source, destination ORDER BY (SELECT NULL)) AS rn
    FROM   city_distance
)
SELECT distance, source, destination
FROM   ranked_rows
WHERE  rn = 1
```

