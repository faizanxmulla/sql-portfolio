### Problem Statement

1. Find total active users each day.

2. Find total active users each week.

3. Find total number of users date-wise who made the purchase the same day, they installed the app.

4. Find the percentage of paid users in India, USA and label other countries as Others.

5. Among all the users who installed the app on a given day, how many did in-app purchase on the very prev day. 


### Schema Setup

```sql
CREATE TABLE activity (
    user_id VARCHAR(20),
    event_name VARCHAR(20),
    event_date DATE,
    country VARCHAR(20)
);

INSERT INTO activity VALUES 
('1', 'app-installed', '2022-01-01', 'India'),
('1', 'app-purchase', '2022-01-02', 'India'),
('2', 'app-installed', '2022-01-01', 'USA'),
('3', 'app-installed', '2022-01-01', 'USA'),
('3', 'app-purchase', '2022-01-03', 'USA'),
('4', 'app-installed', '2022-01-03', 'India'),
('4', 'app-purchase', '2022-01-03', 'India'),
('5', 'app-installed', '2022-01-03', 'SL'),
('5', 'app-purchase', '2022-01-03', 'SL'),
('6', 'app-installed', '2022-01-04', 'Pakistan'),
('6', 'app-purchase', '2022-01-04', 'Pakistan');
```

---
---

### 1. Find total active users each day.

#### Expected Output

event_date | total_active_users | 
--|--|
2022-01-01 | 3 |
2022-01-02 | 1 |
2022-01-03 | 3 |
2022-01-04 | 1 |



#### Solution Query

```sql
SELECT event_date, COUNT(distinct user_id) as total_active_users
FROM   activity
GROUP BY 1
ORDER BY 1
```

---


### 2. Find total active users each week.

#### Expected Output

week_number | total_active_users | 
--|--|
1 | 3 |
2 | 5 |



#### Solution Query

```sql
SELECT   EXTRACT(WEEK FROM event_date) as week_number, COUNT(distinct user_id) as total_active_users
FROM     activity
GROUP BY 1
ORDER BY 1
```

---

### 3. Find total number of users date-wise who made the purchase the same day, they installed the app.

#### Expected Output

event_date | same_day_purchase_user_count | 
--|--|
2022-01-01 | 0 |
2022-01-02 | 0 |
2022-01-03 | 2 |
2022-01-04 | 1 |


#### Solution Query

```sql
WITH same_day_purchase_users AS (
  SELECT   user_id, 
           event_date, 
           CASE WHEN COUNT(DISTINCT event_name) = 2 THEN user_id ELSE NULL END as same_day_purchase_user_id
  FROM     activity
  GROUP BY 1, 2
)
SELECT   event_date, COUNT(DISTINCT same_day_purchase_user_id) as same_day_purchase_user_count
FROM     same_day_purchase_users
GROUP BY 1
```

---

### 4. Find the percentage of paid users in India, the USA, and label users from all other countries as 'Others'.

#### Expected Output

country | percentage_users |
--|--|
India | 40 |
USA | 20 | 
Others | 40 |



#### Solution Query

```sql
WITH paid_users_cte AS (
    SELECT   CASE WHEN country IN ('India', 'USA') then country ELSE 'Others' END as country, 			  
             COUNT(1) AS paid_users
    FROM     activity
    WHERE    event_name='app-purchase'
    GROUP BY 1
),
total_users_cte AS (
    SELECT SUM(paid_users) as total_users
    FROM   paid_users_cte
)
SELECT p.country, 100.0 * ROUND(p.paid_users / t.total_users, 2) AS percentage_paid_users
FROM   paid_users_cte p CROSS JOIN total_users_cte t
```

---

### 5. Among all the users who installed the app on a given day, how many did in-app purchase on the very prev day? Provide date-wise results.

#### Expected Output

event_date | purchase_prev_day_count | 
--|--|
2022-01-01 | 0 |
2022-01-02 | 1 |
2022-01-03 | 0 |
2022-01-04 | 0 |



#### Solution Query

```sql
WITH CTE AS (
    SELECT user_id, 
           event_name, 
           event_date, 
           LAG(event_name) OVER(PARTITION BY user_id ORDER BY event_date) as prev_event_name,
           LAG(event_date) OVER(PARTITION BY user_id ORDER BY event_date) as prev_event_date
    FROM   activity
)
SELECT   prev_event_date as event_date, 
         SUM(CASE WHEN event_name = 'app-purchase' AND 
         			   prev_event_name = 'app-installed' AND 
         			   event_date = prev_event_date + INTERVAL '1 DAY'
                  THEN 1 ELSE 0 END) AS purchase_prev_day_count
FROM     CTE
GROUP BY 1
ORDER BY 1
```

---
