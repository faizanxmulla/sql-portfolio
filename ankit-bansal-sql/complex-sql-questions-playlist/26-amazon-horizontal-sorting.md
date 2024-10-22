### Problem Statement

Find the total number of messages exchanged between each person each day.

### Schema Setup

```sql
CREATE TABLE subscriber (
    sms_date DATE ,
    sender VARCHAR(20) ,
    receiver VARCHAR(20) ,
    sms_no INT
);

INSERT INTO subscriber VALUES 
('2020-4-1', 'Avinash', 'Vibhor',10),
('2020-4-1', 'Vibhor', 'Avinash',20),
('2020-4-1', 'Avinash', 'Pawan',30),
('2020-4-1', 'Pawan', 'Avinash',20),
('2020-4-1', 'Vibhor', 'Pawan',5),
('2020-4-1', 'Pawan', 'Vibhor',8),
('2020-4-1', 'Vibhor', 'Deepak',50);
```

### Expected Output

sms_date |	person1 |	person2 |	total_messages_exchanged |
--|--|--|--|
2020-04-01 |  Avinash |	Pawan |	50 |
2020-04-01 |  Deepak |	Vibhor |	50 |
2020-04-01 |  Avinash |	Vibhor |	30 |
2020-04-01 |  Pawan |	Vibhor |	13 |

### Solution Query

```sql
-- Solution 1: using CASE WHEN

WITH CTE AS (
    SELECT sms_date,
           sms_no, 
           CASE WHEN sender < receiver THEN sender ELSE receiver END AS person1,
           CASE WHEN sender > receiver THEN sender ELSE receiver END AS person2
    FROM   subscriber
)
SELECT   sms_date, person1, person2, SUM(sms_no) AS total_messages_exchanged
FROM     CTE
GROUP BY 1, 2, 3


-- Solution 2: using LEAST & GREATEST

WITH CTE AS (
    SELECT sms_date,
           sms_no, 
           LEAST(sender, receiver) as person1,
           GREATEST(sender, receiver) as person2
    FROM   subscriber
)
SELECT   sms_date, person1, person2, SUM(sms_no) as total_messages_exchanged
FROM     CTE
GROUP BY 1, 2, 3
```

