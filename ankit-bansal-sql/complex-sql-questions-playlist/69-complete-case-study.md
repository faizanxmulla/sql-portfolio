### Problem Statement

Test Guidelines: 

- The test should take about 60 minutes to complete.

- Please review the following data model. Assume the columns are never full.

- Write your SQL result under the question.

- You can wite assumptions in case something is unclear.

**List of questions**:

1. Management wants to see all the users that did not login in the past 5 months.

2. For the business unit's quarterly analysis, calculate how many users and sessions were at each quarter.

3. Display the user_id's that log-in in Januray 2024 and did not login in November 2023.

4. Add a query to question 2, to find the percentage change in sessions from last quarter.

5. Display the user that had the highest session score (max) for each day.

6. To identify the best users; return the users that had a session on every single day since their first login.

7. On what dates there were no logins at all? 


### Schema Setup

```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(20) NOT NULL,
    user_status VARCHAR(20) NOT NULL
);

CREATE TABLE logins (
    user_id INT,
    login_timestamp TIMESTAMP NOT NULL,
    session_id INT PRIMARY KEY,
    session_score INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


INSERT INTO users VALUES 
(1, 'Alice', 'Active'),
(2, 'Bob', 'Inactive'),
(3, 'Charlie', 'Active'),
(4, 'David', 'Active'),
(5, 'Eve', 'Inactive'),
(6, 'Frank', 'Active'),
(7, 'Grace', 'Inactive'),
(8, 'Heidi', 'Active'),
(9, 'Ivan', 'Inactive'),
(10, 'Judy', 'Active');

INSERT INTO logins VALUES 
(1, '2023-07-15 09:30:00', 1001, 85),
(2, '2023-07-22 10:00:00', 1002, 90),
(3, '2023-08-10 11:15:00', 1003, 75),
(4, '2023-08-20 14:00:00', 1004, 88),
(5, '2023-09-05 16:45:00', 1005, 82),
(6, '2023-10-12 08:30:00', 1006, 77),
(7, '2023-11-18 09:00:00', 1007, 81),
(8, '2023-12-01 10:30:00', 1008, 84),
(9, '2023-12-15 13:15:00', 1009, 79);


-- 2024 Q1
INSERT INTO logins (user_id, login_timestamp, session_id, session_score) VALUES
(1, '2024-01-10 07:45:00', 1011, 86),
(2, '2024-01-25 09:30:00', 1012, 89),
(3, '2024-02-05 11:00:00', 1013, 78),
(4, '2024-03-01 14:30:00', 1014, 91),
(5, '2024-03-15 16:00:00', 1015, 83),
(6, '2024-04-12 08:00:00', 1016, 80),
(7, '2024-05-18 09:15:00', 1017, 82),
(8, '2024-05-28 10:45:00', 1018, 87),
(9, '2024-06-15 13:30:00', 1019, 76),
(10, '2024-06-25 15:00:00', 1010, 92),
(10, '2024-06-26 15:45:00', 1020, 93),
(10, '2024-06-27 15:00:00', 1021, 92),
(10, '2024-06-28 15:45:00', 1022, 93),
(1, '2024-01-10 07:45:00', 1101, 86),
(3, '2024-01-25 09:30:00', 1102, 89),
(5, '2024-01-15 11:00:00', 1103, 78),
(2, '2023-11-10 07:45:00', 1201, 82),
(4, '2023-11-25 09:30:00', 1202, 84),
(6, '2023-11-15 11:00:00', 1203, 80);
```

### Solution Queries 

Q1) Management wants to see all the users that did not login in the past 5 months. 

**Return:** username


```sql
-- Solution 1: using MAX() and HAVING.

SELECT   user_name
FROM     users u LEFT JOIN logins l USING(user_id)
GROUP BY 1
HAVING   MAX(login_timestamp) < '2024-06-29'::DATE - INTERVAL '5 months'


-- Solution 2: using NOT IN and subquery.

SELECT DISTINCT user_id
FROM   logins
WHERE  user_id NOT IN (
    SELECT user_id
    FROM   logins
    WHERE  login_timestamp > '2024-06-29'::DATE - INTERVAL '5 months'
)
```

---
---

Q2) For the business unit's quarterly analysis, calculate how many users and sessions were at each quarter. Order by quarter from newest to oldest. 

**Return**: First day of quarter, user_count and session_count


```sql
SELECT   DATE_TRUNC('Quarter', login_timestamp) as first_day_of_quarter,
	     EXTRACT(QUARTER FROM login_timestamp) as quarter_number,
	     COUNT(DISTINCT user_id) as user_count, 
	     COUNT(session_id) as session_count     
FROM     logins
GROUP BY 1, 2
ORDER BY 1
```

---
---

Q3) Display the user_id's that log-in in Januray 2024 and did not login in November 2023.

**Return**: user ID

```sql
SELECT DISTINCT user_id
FROM   logins
WHERE  TO_CHAR(login_timestamp, 'YYYY-MM') = '2024-01' and user_id NOT IN (
	SELECT user_id
	FROM   logins
	WHERE  TO_CHAR(login_timestamp, 'YYYY-MM') = '2023-11'
)


-- NOTE: 

-- earlier I was just doing :
-- WHERE  TO_CHAR(login_timestamp, 'YYYY-MM') = '2024-01' and TO_CHAR(login_timestamp, 'YYYY-MM') <> '2023-11'
```

---
---

Q4) Add a query to question 2, to find the percentage change in sessions from last quarter.

**Return**: First day of quarter, session_count, prev_session_count, session_percent_change


```sql
WITH CTE as (
	SELECT   DATE_TRUNC('Quarter', login_timestamp) as first_day_of_quarter,
		     EXTRACT(QUARTER FROM login_timestamp) as quarter_number,
		     COUNT(DISTINCT user_id) as user_count, 
		     COUNT(session_id) as session_count     
	FROM     logins
	GROUP BY 1, 2
	ORDER BY 1
)
SELECT first_day_of_quarter, 
	   quarter_number,
	   session_count,
	   LAG(session_count) OVER(ORDER BY first_day_of_quarter) as prev_session_count,
	   100.0 * (session_count - LAG(session_count) OVER(ORDER BY first_day_of_quarter)) / LAG(session_count) OVER(ORDER BY first_day_of_quarter) as session_percentage_change 
FROM   CTE
```

---
---

Q5) Display the user that had the highest session score (MAX) for each day.

**Return**: date, username, score


```sql
WITH CTE as (
    SELECT   user_id, DATE(login_timestamp) as login_date, SUM(session_score) as total_session_score
    FROM     logins
    GROUP BY 1, 2
)
SELECT user_id, login_date, total_session_score
FROM  (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY login_date ORDER BY total_session_score DESC) as rn
    FROM   CTE
) X
WHERE rn=1
```

---
---

Q6) To identify the best users; return the users that had a session on every single day since their first login.

**Return**: user_id


```sql
SELECT   user_id, 
         MIN(CAST(login_timestamp AS DATE)) AS first_login,
         DATEDIFF(day, MIN(CAST(login_timestamp AS DATE)), GETDATE()) + 1 AS no_of_login_days_required,
         COUNT(DISTINCT CAST(login_timestamp AS DATE)) AS no_of_login_days
FROM     logins
GROUP BY 1
HAVING   DATEDIFF(day, MIN(CAST(login_timestamp AS DATE)), GETDATE()) + 1 > COUNT(DISTINCT CAST(login_timestamp AS DATE))
ORDER BY 1

```

---
---

Q7) On what dates there were no logins at all? 

**Return**: login_dates


```sql

```

---
---



