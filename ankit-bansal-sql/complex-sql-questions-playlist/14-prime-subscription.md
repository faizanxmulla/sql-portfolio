### Problem Statement

Given the `users` and `events` tables, return the fraction of users, rounded to two decimal places, who accessed Amazon Music and upgraded to Prime membership within the first 30 days of signing up.

The output should return a single value representing the fraction of users who meet the above criteria.


### Schema Setup

```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    join_date DATE
);

INSERT INTO users (user_id, name, join_date) VALUES
(1, 'Jon', '2020-02-14'),
(2, 'Jane', '2020-02-14'),
(3, 'Jill', '2020-02-14'),
(4, 'Josh', '2020-02-15'),
(5, 'Jean', '2020-02-16'),
(6, 'Justin', '2020-02-17'),
(7, 'Jeremy', '2020-02-18');

CREATE TABLE events (
    user_id INT,
    type VARCHAR(50),
    access_date DATE
);

INSERT INTO events (user_id, type, access_date) VALUES
(1, 'Pay', '2020-03-01'),
(2, 'MLack', '2020-03-02'),
(2, 'P', '2020-03-12'),
(3, 'Music', '2020-03-15'),
(3, 'P', '2020-03-15'),
(6, 'P', '2020-03-16'),
(7, 'P', '2020-03-22');
```


### Expected Output

fraction |
--|
33.33 |

### Solution Query

```sql
WITH events_cte AS (
    SELECT   user_id, 
             access_date,
             COUNT(*) FILTER(WHERE type='Music') as music_members, 
             COUNT(*) FILTER(WHERE type='P') as prime_members
    FROM     events
    GROUP BY 1, 2
)
SELECT 100.0 * ROUND(SUM(music_members) / SUM(prime_members), 2) as fraction
FROM   events_cte e JOIN users u USING(user_id)
WHERE  access_date <= join_date + INTERVAL '30 day'
```