### Problem Statement

There are 3 rows in a movie hall each with 10 seats in each row. 

Write SQL query to find 4 consecutive empty seats.

### Schema Setup

```sql
CREATE TABLE movie (
    seat VARCHAR(50),
    occupancy INT
);

INSERT INTO movie VALUES
('a1', 1), ('a2', 1), ('a3', 0), ('a4', 0),('a5', 0),('a6', 0),('a7', 1),('a8', 1),('a9', 0),('a10', 0),
('b1', 0),('b2', 0),('b3', 0),('b4', 1),('b5', 1),('b6', 1),('b7', 1),('b8', 0),('b9', 0),('b10', 0),
('c1', 0),('c2', 1),('c3', 0),('c4', 1),('c5', 1),('c6', 0),('c7', 1),('c8', 0),('c9', 0),('c10', 1);
```

### Expected Output

seat |
--|
a3 |
a4 |
a5 |
a6 |


### Solution Query

```sql
WITH split_seat_number AS (
    SELECT seat, 
           LEFT(seat, 1) AS row,
           CAST(RIGHT(seat, LENGTH(seat) - 1) AS INT) AS seat_number, 
           occupancy
    FROM   movie
    WHERE  occupancy=0
),
create_bins AS (
    SELECT seat, row, seat_number - ROW_NUMBER() OVER(PARTITION BY row ORDER BY seat_number) as bin
    FROM   split_seat_number
),
count_records_per_bin AS (
    SELECT *, COUNT(1) OVER(PARTITION BY row, bin) as records_per_bin
    FROM   create_bins
)
SELECT   seat
FROM     count_records_per_bin
WHERE    records_per_bin >= 4
ORDER BY 1
```