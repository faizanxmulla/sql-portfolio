### Problem Statement

For each user who signed up on FB after 2020-01-01, what is the proportion of time spent per event type? 

Assume that there's no duplication and missingness in the records. Return the name, user_id, event, and proportion.

### Schema setup

```sql
CREATE TABLE "user" (
    date_signup DATE,
    user_id INT,
    name VARCHAR(255)
);

INSERT INTO "user" (date_signup, user_id, name) VALUES
('2021-02-01', 1, 'Kathy Smith'),
('2021-02-02', 2, 'John Doe'),
('2021-02-03', 3, 'Henry Dill'),
('2021-02-02', 4, 'Kyle Johnson');


CREATE TABLE activity (
    datetime DATETIME,
    user_id INT,
    event VARCHAR(50),
    time_spent FLOAT
);

INSERT INTO activity (datetime, user_id, event, time_spent) VALUES
('2021-02-01 04:15:13', 1, 'Post', 1),
('2021-02-01 08:03:03', 1, 'Signup', 1.5),
('2021-02-01 08:18:13', 1, 'Share', 2),
('2021-02-02 05:16:16', 1, 'Browse', 1.5),
('2021-02-02 12:15:33', 2, 'Search', 3);
```

### Solution Query

```sql
WITH time_per_user_event_cte AS (
	SELECT   name, user_id, event, SUM(time_spent) AS time_per_user_event
	FROM     "User" u JOIN Activity a USING(user_id)
	WHERE    date_signup > '2020-01-01'
	GROUP BY 1, 2, 3
),
time_per_user_cte AS (
	SELECT   user_id, SUM(time_per_user_event) AS time_per_user
	FROM     time_per_user_event_cte
	GROUP BY 1
)
SELECT name, user_id, event, ROUND(time_per_user_event::numeric / time_per_user::numeric, 2) as proportion
FROM   time_per_user_event_cte ue JOIN time_per_user_cte u USING(user_id)
```

