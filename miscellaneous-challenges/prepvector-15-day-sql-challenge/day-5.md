## Post Completion Rate Analysis

### Problem Statement 

Consider the events table, which contains information about the phases of writing a new social media post.

The action column can have values `post_enter`, `post_submit`, or `post_canceled` for when a user starts to write (`post_enter`), ends up canceling their post (`post_cancel`), or posts it (`post_submit`). Write a query to get the post-success rate for each day in the month of January 2020.

`Note:` Post Success Rate is defined as the number of posts submitted (`post_submit`) divided by the number of posts entered (`post_enter`) for each day.


### Schema setup 

```sql
CREATE TABLE events (
    user_id INT,
    created_at DATETIME,
    action VARCHAR(20)
);

INSERT INTO events VALUES
(1, '2020-01-01 10:00:00', 'post_enter'),
(1, '2020-01-01 10:05:00', 'post_submit'),
(2, '2020-01-01 11:00:00', 'post_enter'),
(2, '2020-01-01 11:10:00', 'post_canceled'),
(3, '2020-01-01 15:00:00', 'post_enter'),
(3, '2020-01-01 15:30:00', 'post_submit'),
(4, '2020-01-02 09:00:00', 'post_enter'),
(4, '2020-01-02 09:15:00', 'post_canceled'),
(5, '2020-01-02 10:00:00', 'post_enter'),
(5, '2020-01-02 10:10:00', 'post_canceled'),
(10, '2020-01-15 14:00:00', 'post_enter'),
(10, '2020-01-15 14:30:00', 'post_submit'),
(6, '2019-12-31 23:55:00', 'post_enter'),
(6, '2020-01-01 00:05:00', 'post_submit'),
(7, '2020-02-01 00:00:00', 'post_enter'),
(7, '2020-02-01 00:10:00', 'post_submit'),
(8, '2019-01-15 10:00:00', 'post_enter'),
(8, '2019-01-15 10:30:00', 'post_submit'),
(9, '2021-01-01 09:00:00', 'post_enter'),
(9, '2021-01-01 09:10:00', 'post_canceled');
```

### Expected Output 

date |	total_enters |	total_submits |	success_rate |
--|--|--|--|
2020-01-01 |	3 |	2 |	66.6667 |
2020-01-02 |	2 |	0 |	0 |
2020-01-15 |	1 |	1 |	100 |


### Solution Query 

```sql
SELECT   date(created_at) as date,
         SUM(CASE WHEN action='post_enter' THEN 1 ELSE 0 END) as total_enters,
         SUM(CASE WHEN action='post_submit' THEN 1 ELSE 0 END) as total_submits,
         IFNULL(1.0 * SUM(CASE WHEN action='post_submit' THEN 1 ELSE 0 END) / 
                 NULLIF(SUM(CASE WHEN action='post_enter' THEN 1 ELSE 0 END), 0), 0) as success_rate
FROM     events
WHERE    created_at >= '2020-01-01 00:00:00' and created_at < '2020-02-01 00:00:00'
GROUP BY date



-- NOTE: However, this solution is currently getting 8/10 points instead of a full score. There might be an edge case I’m missing


-- updated solution:

-- current query counts post_enter and post_submit separately based on the created_at date, but it doesn’t ensure that a post_submit corresponds to an actual post_enter on the same day.


WITH enters as (
    SELECT user_id, DATE(created_at) as enter_date
    FROM   events
    WHERE  action = 'post_enter'
)
,submits as (
    SELECT user_id, DATE(created_at) as submit_date
    FROM   events
    WHERE  action = 'post_submit'
)
SELECT   e.enter_date as date,
         COUNT(e.user_id) as total_enters,
         COUNT(s.user_id) as total_submits,
         IFNULL(100.0 * COUNT(s.user_id) / NULLIF(COUNT(e.user_id), 0), 0) as success_rate
FROM     enters e LEFT JOIN submits s ON e.user_id = s.user_id and e.enter_date = s.submit_date
WHERE    date BETWEEN '2020-01-01' and '2020-01-31'
GROUP BY e.enter_date
```