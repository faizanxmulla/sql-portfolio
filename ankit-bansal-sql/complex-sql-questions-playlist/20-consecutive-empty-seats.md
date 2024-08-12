### Problem Statement

Write an SQL query to identify the seat numbers that have three or more consecutive empty seats. The table consists of `seat_no` and `is_empty` columns where `is_empty` indicates whether the seat is empty ('Y') or not ('N').

### Schema Setup

```sql
CREATE TABLE Seats (
    seat_no INT,
    is_empty CHAR(1)
);

INSERT INTO Seats VALUES
(1,'N'),
(2,'Y'),
(3,'N'),
(4,'Y'),
(5,'Y'),
(6,'Y'),
(7,'N'),
(8,'Y'),
(9,'Y'),
(10,'Y'),
(11,'Y'),
(12,'N'),
(13,'Y'),
(14,'Y');
```

### Expected Output

seat_no |
--|
4 |
5 |
6 |
8 |
9 |
10 |
11 |

### Solution Query

```sql
-- Solution 1: using analytical row number function

WITH consecutive_empty_seats AS (
    SELECT *, seat_no - ROW_NUMBER() OVER(ORDER BY seat_no) AS consecutive_grp
    FROM   Seats
    WHERE  is_empty = 'Y'
),
groups_with_three_or_more AS (
    SELECT   consecutive_grp
    FROM     consecutive_empty_seats
    GROUP BY 1
    HAVING   COUNT(1) >= 3
)
SELECT seat_no 
FROM   consecutive_empty_seats 
WHERE  consecutive_grp IN (SELECT consecutive_grp FROM groups_with_three_or_more)



-- Solution 2: using LEAD / LAG window functions

WITH seats_configuration AS (
    SELECT *,
           LAG(is_empty, 1) OVER (ORDER BY seat_no) AS prev_1,
           LAG(is_empty, 2) OVER (ORDER BY seat_no) AS prev_2,
           LEAD(is_empty, 1) OVER (ORDER BY seat_no) AS next_1,
           LEAD(is_empty, 2) OVER (ORDER BY seat_no) AS next_2
    FROM   Seats
)
SELECT seat_no
FROM   seats_configuration
WHERE  (is_empty = 'Y' AND prev_1 = 'Y' AND prev_2 = 'Y') OR
       (is_empty = 'Y' AND next_1 = 'Y' AND next_2 = 'Y') OR
       (is_empty = 'Y' AND prev_1 = 'Y' AND next_1 = 'Y')



-- Solution 3: using advanced aggregation

WITH seat_analysis AS (
    SELECT *,
           SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) 
               OVER (ORDER BY seat_no ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS prev_2,
           SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) 
               OVER (ORDER BY seat_no ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS prev_next_1,
           SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) 
               OVER (ORDER BY seat_no ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS next_2
    FROM   Seats
)
SELECT seat_no
FROM   seat_analysis
WHERE  prev_2 = 3 OR
       prev_next_1 = 3 OR 
       next_2 = 3;
```