### Problem Statement

Write an SQL query to show the second most recent activity of each user. If the user only has one activity, return that one.

A user can't perform more than one activity at the same time. Return the result table in any order.


### Schema Setup

```sql
CREATE TABLE UserActivity (
    username   VARCHAR(20),
    activity   VARCHAR(20),
    startDate  DATE,
    endDate    DATE
);

INSERT INTO UserActivity (username, activity, startDate, endDate) VALUES 
('Alice', 'Travel', '2020-02-12', '2020-02-20'),
('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
('Alice', 'Travel', '2020-02-24', '2020-02-28'),
('Bob', 'Travel', '2020-02-11', '2020-02-18');
```

### Expected Output


| username   | activity     | startDate   | endDate     |
|------------|--------------|-------------|-------------|
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |


### Solution Query

```sql
WITH ranked_activities AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY username ORDER BY startdate desc) AS rn,
           COUNT(*) OVER(PARTITION BY username) AS count
    FROM   UserActivity
)
SELECT username, activity, startdate, enddate
FROM   ranked_activities
WHERE  rn=2 OR count=1
```



