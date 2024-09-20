### Problem Statement

Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, then the id of the last student is not swapped.

### Schema Setup

```sql
CREATE TABLE seats (
    id INT,
    student VARCHAR(10)
);

INSERT INTO seats VALUES 
(1, 'Amit'),
(2, 'Deepa'),
(3, 'Rohit'),
(4, 'Anjali'),
(5, 'Neha'),
(6, 'Sanjay'),
(7, 'Priya')
```

### Expected Output

| updated_id | student |
|------------|---------|
| 1          | Deepa   |
| 2          | Amit    |
| 3          | Anjali  |
| 4          | Rohit   |
| 5          | Sanjay  |
| 6          | Neha    |
| 7          | Priya   |


### Solution

```sql
-- Solution 1: using LEAD() and LAG() window functions // also will work in case of non-consecutive 

WITH CTE AS (
    SELECT id,
           student,
           LAG(id) OVER(ORDER BY id) AS prev_id,
           LEAD(id) OVER(ORDER BY id) AS next_id
    FROM   seats
)
SELECT   CASE WHEN id % 2 = 1 AND next_id IS NOT NULL THEN next_id
              WHEN id % 2 = 0 THEN prev_id                       
            ELSE id 
         END AS updated_id,
         student
FROM     CTE


-- Solution 2: using MAX() and CASE WHEN 

SELECT   CASE WHEN id = (SELECT MAX(id) FROM seats) and id%2=1 THEN id
       		WHEN id%2=0 THEN id-1
          ELSE id+1
         END AS updated_id,
         student
FROM     seats
ORDER BY 1


-- Update statement:

UPDATE seats 
SET    seat_id = updated_seats.updated_id
FROM   (
    SELECT CASE WHEN id = (SELECT MAX(id) FROM seats) and id%2=1 THEN id
       		    WHEN id%2=0 THEN id-1
           ELSE id+1 END AS updated_id
) updated_seats
WHERE  seats.id=updated_seats.id
```

