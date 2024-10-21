### Problem Statement | [Leetcode Link](https://leetcode.com/problems/human-traffic-of-stadium/description/)

Write a solution to display the records with three or more rows with **consecutive** id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in **ascending order**.


### Schema Setup

```sql
CREATE TABLE stadium (
    id INT,
    visit_date DATE,
    no_of_people INT
);

INSERT INTO stadium (id, visit_date, no_of_people) VALUES
(1, '2017-07-01', 10),
(2, '2017-07-02', 109),
(3, '2017-07-03', 150),
(4, '2017-07-04', 99),
(5, '2017-07-05', 145),
(6, '2017-07-06', 1455),
(7, '2017-07-07', 199),
(8, '2017-07-08', 188);
```


### Expected Output

| id   | visit_date | people    |
|------|------------|-----------|
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |


### Solution Query

```sql
WITH consecutive_dates AS (
    SELECT id, visit_date, no_of_people, id - ROW_NUMBER() OVER() as bin
    FROM   stadium
    WHERE  no_of_people > 100
),
records_cte as (
    SELECT *, COUNT(1) OVER(PARTITION BY bin) as records_in_each_bin
    FROM   consecutive_dates
)
SELECT id, visit_date, no_of_people
FROM   records_cte
WHERE  records_in_each_bin >= 3
```
