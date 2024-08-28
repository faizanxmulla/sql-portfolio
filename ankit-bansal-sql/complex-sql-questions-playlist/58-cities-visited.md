### Problem Statement

You are given the travel data for each customer in no particular order. You need to find the start location and end location of the customer.

Got this problem from here: [Ankit Bansal LinkedIn Post](https://www.linkedin.com/posts/ankitbansal6_sql-analytics-activity-7234404172127744000-edLt?utm_source=share&utm_medium=member_desktop)

Original Problem Link: [Leetcode DSA - Easy](https://leetcode.com/problems/destination-city/description/)

### Schema setup

```sql
CREATE TABLE travel_data (
    customer VARCHAR(10),
    start_location VARCHAR(50),
    end_location VARCHAR(50)
);

INSERT INTO travel_data (customer, start_location, end_location) VALUES
('c1', 'New York', 'Lima'),
('c1', 'London', 'New York'),
('c1', 'Lima', 'Sao Paulo'),
('c1', 'Sao Paulo', 'New Delhi'),
('c2', 'Mumbai', 'Hyderabad'),
('c2', 'Surat', 'Pune'),
('c2', 'Hyderabad', 'Surat'),
('c3', 'Kochi', 'Kurnool'),
('c3', 'Lucknow', 'Agra'),
('c3', 'Agra', 'Jaipur'),
('c3', 'Jaipur', 'Kochi');
```

### Solution Query

```sql
WITH travel_cte as (
    SELECT customer, start_location as cities_visited, 'start' as start_or_end
    FROM   travel_data
    UNION ALL
    SELECT customer, end_location as cities_visited, 'end' as start_or_end
    FROM   travel_data
), 
count_cte as (
    SELECT   *, COUNT(*) OVER(PARTITION BY customer, cities_visited) as count
    FROM     travel_cte
    ORDER BY customer, cities_visited
),
total_visited_cte AS (
    SELECT   customer, COUNT(DISTINCT cities_visited) AS total_visited
    FROM     travel_cte
    GROUP BY 1
)
SELECT   customer, 
         MAX(CASE WHEN start_or_end='start' THEN cities_visited END) as start_location,
         MAX(CASE WHEN start_or_end='end' THEN cities_visited END) as end_location,
         total_visited
FROM     count_cte cc JOIN total_visited_cte tvc USING(customer)
WHERE    count=1
GROUP BY 1, 4
ORDER BY 1
```

### Output


customer | start_location | end_location | total_visited |
--|--|--|--|
c1 | London | New Delhi | 5 |
c2 | Mumbai | Pune | 4 |
c3 | Lucknow | Kurnool | 5