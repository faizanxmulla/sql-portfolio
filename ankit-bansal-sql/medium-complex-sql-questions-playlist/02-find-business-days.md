### Problem Statement

Write a SQL query to find business days between created date and resolved date, excluding the weekends and public holidays.


### Schema Setup

```sql
CREATE TABLE tickets (
    ticket_id VARCHAR(10),
    create_date DATE,
    resolved_date DATE
);

DELETE FROM tickets;

INSERT INTO tickets VALUES
(1, '2022-08-01', '2022-08-03'),
(2, '2022-08-01', '2022-08-12'),
(3, '2022-08-01', '2022-08-16');


CREATE TABLE holidays (
    holiday_date DATE,
    reason VARCHAR(100)
);

DELETE FROM holidays;

INSERT INTO holidays VALUES
('2022-08-11', 'Rakhi'),
('2022-08-15', 'Independence day');
```

### Expected Output

ticket_id |	business_days |
--|--|
1 |	3 |
2 |	9 |
3 |	10 |


### Solution

```sql
-- my approach

WITH RECURSIVE date_range AS (
    SELECT t.ticket_id,
           t.create_date AS curr_date,
           t.resolved_date
    FROM   tickets t
    UNION ALL
    SELECT t.ticket_id,
           (dr.curr_date + INTERVAL '1 DAY')::DATE AS curr_date,
           dr.resolved_date
    FROM   date_range dr JOIN tickets t USING(ticket_id)
    WHERE  dr.curr_date < t.resolved_date
),
business_days AS (
    SELECT ticket_id, curr_date
    FROM   date_range
    WHERE  EXTRACT(ISODOW FROM curr_date) NOT IN (6, 7)
),
final_business_days AS (
    SELECT bd.ticket_id, bd.curr_date
    FROM   business_days bd LEFT JOIN holidays h ON bd.curr_date = h.holiday_date
    WHERE  h.holiday_date IS NULL
)
SELECT   ticket_id, COUNT(curr_date) AS business_days
FROM     final_business_days
GROUP BY 1
ORDER BY 1


-- NOTE: 

-- in the video he has used different approach, much shorter. 

-- also my approach is giving a slight different answer; like instead of 2, 8, 9 it is giving 3, 9, 10 in the business days column.

-- but I cant seem to figure out the mistake.
```

