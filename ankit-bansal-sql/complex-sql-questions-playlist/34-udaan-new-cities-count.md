### Problem Statement

Write a SQL query to identify the yearwise count of new cities where Udaan started their operations.

### Schema Setup

```sql
CREATE TABLE business_city (
    business_date DATE,
    city_id INT
);

INSERT INTO business_city (business_date, city_id) VALUES
('2020-01-02', 3),
('2020-07-01', 7),
('2021-01-01', 3),
('2021-02-03', 19),
('2022-12-01', 3),
('2022-12-15', 3),
('2022-02-28', 12);
```

### Expected Output

| year | new_cities   |
|------|--------------|
| 2020 | 2            |
| 2021 | 1            |
| 2022 | 1            |


### Solution Query

```sql
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY city_id ORDER BY business_date) AS rn
    FROM   business_city
)
SELECT   EXTRACT(YEAR FROM business_date) AS year, COUNT(DISTINCT city_id) AS new_cities
FROM     CTE
WHERE    rn = 1
GROUP BY 1
ORDER BY 1
```