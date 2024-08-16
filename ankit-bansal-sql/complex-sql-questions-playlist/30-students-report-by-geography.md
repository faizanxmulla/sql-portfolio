### Problem Statement | [Leetcode Link](https://leetcode.com/problems/students-report-by-geography/description/)

Given a table with two columns `name` and `city`, pivot the data such that cities become columns and the names of the individuals who belong to those cities are the values.


### Schema Setup

```sql
CREATE TABLE people (
    name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO people (name, city) VALUES
('Sachin', 'Mumbai'),
('Virat', 'Delhi'),
('Rahul', 'Bangalore'),
('Rohit', 'Mumbai'),
('Mayank', 'Bangalore');
```


### Expected Output

| Bangalore | Mumbai | Delhi |
|-----------|--------|-------|
| Mayank    | Rohit  | Virat |
| Rahul     | Sachin | NULL  |

### Solution Query

```sql
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY city ORDER BY name) AS rn
    FROM   people
)
SELECT   MIN(CASE WHEN city='Bangalore' THEN name END) AS 'Bangalore',
         MIN(CASE WHEN city='Mumbai' THEN name END) AS 'Mumbai',
         MIN(CASE WHEN city='Delhi' THEN name END) AS 'Delhi'
FROM     CTE
GROUP BY rn
```



