### Problem Statement

Given a `call_log` table that contains information about callers' call history, write a SQL query to find callers whose first and last call was to the same person on a given day.

### Schema Setup

```sql
CREATE TABLE call_log (
   caller_id INT,
   recipient_id INT,
   date_called DATETIME
);

INSERT INTO call_log (caller_id, recipient_id, date_called) VALUES 
(1, 2, '2019-01-01 09:00:00'),
(1, 3, '2019-01-01 17:00:00'),
(1, 4, '2019-01-01 23:00:00'),
(2, 5, '2019-07-05 09:00:00'),
(2, 3, '2019-07-05 17:00:00'),
(2, 3, '2019-07-05 17:20:00'),
(2, 5, '2019-07-05 23:00:00'),
(2, 3, '2019-08-01 09:00:00'),
(2, 3, '2019-08-01 17:00:00'),
(2, 5, '2019-08-01 19:30:00'),
(2, 4, '2019-08-02 09:00:00'),
(2, 5, '2019-08-02 10:00:00'),
(2, 5, '2019-08-02 10:45:00'),
(2, 4, '2019-08-02 11:00:00')
```

### Solution Query

```sql
WITH calls_cte as (
    SELECT   DATE(date_called) as date, 
             caller_id,
             MIN(date_called) as first_call,
             MAX(date_called) as last_call
    FROM     call_log
    GROUP BY 1, 2
    ORDER BY 1, 2
)
SELECT date,
       c.caller_id,
       cl1.recipient_id as recipient_id
FROM   calls_cte c JOIN call_log cl1 ON c.caller_id=cl1.caller_id AND c.first_call=cl1.date_called 
                   JOIN call_log cl2 ON c.caller_id=cl2.caller_id AND c.last_call=cl2.date_called
WHERE  cl1.recipient_id = cl2.recipient_id
```

