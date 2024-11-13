## Microsoft Data Analyst Interview Experience (1-5 years) 

### 1. Most Popular Client I

Select the most popular client_id based on a count of the number of users who have at least 50% of their events from the following list: ‘video call received’, ‘video call sent’, ‘voice call received’, ‘voice call sent’.

**Solution Query:**

```sql
WITH users_cte as (
    SELECT   client_id,
             COUNT(DISTINCT user_id) as total_users,
             COUNT(DISTINCT user_id) FILTER(WHERE event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent')) as filtered_users
    FROM     events
    GROUP BY client_id
)
SELECT client_id
FROM   users_cte
WHERE  filtered_users >= 0.5 * total_users
```

---

### 2. Desktop-Only Users

Write a query that returns the company (customer_id column) with the highest number of users that use desktop only.



**Solution Query:**

```sql
WITH desktop_only_users as (
    SELECT   customer_id,
             user_id
    FROM     events
    GROUP BY 1, 2
    HAVING   COUNT(DISTINCT CasE WHEN client_id <> 'desktop' THEN client_id END) = 0
)
SELECT   customer_id,
         COUNT(DISTINCT user_id) as desktop_only_user_count
FROM     desktop_only_users
GROUP BY 1
ORDER BY 2 DESC
```


---

### 3. Bottom Companies by Mobile Usage

Write a query that returns a list of the bottom 2 companies by mobile usage. Company is defined in the customer_id column. Mobile usage is defined as the number of events registered on a client_id == 'mobile'. Order the result by the number of events ascending. In the case where there are multiple companies tied for the bottom ranks (rank 1 or 2), return all the companies. Output the customer_id and number of events.


**Solution Query:**


```sql
WITH ranked_usage as (
    SELECT   customer_id,
             COUNT(*) as mobile_event_count,
             RANK() OVER (ORDER BY COUNT(*)) as rn
    FROM     events
    WHERE    client_id = 'mobile'
    GROUP BY customer_id
)
SELECT customer_id, mobile_event_count
FROM   ranked_usage
WHERE  rn < 3
```

---

### 4. Exclusive Users per Client

Write a query that returns a number of users who are exclusive to only one client. Output the client_id and number of exclusive users.

**Solution Query:**

```sql

SELECT   client_id, COUNT(DISTINCT user_id) as exclusive_users
FROM     events
GROUP BY client_id
HAVING   COUNT(DISTINCT customer_id) = 1
```


---

### 5. Unique Users per Client per Month

Write a query that returns the number of unique users per client per month.


**Solution Query:**

```sql
SELECT   client_id, 
         EXTRACT(MONTH FROM time_id) as month,
         COUNT(DISTINCT user_id) as user_count
FROM     events
GROUP BY 1, 2
```


---

### 6. Monthly User Share (New v/s Existing)


Calculate the share of new and existing users for each month in the table. Output the month, share of new users, and share of existing users as a ratio. 

- New users are defined as users who started using services in the current month (there is no usage history in previous months). 

- Existing users are users who used services in the current month but also used services in any previous month. 

Assume that the dates are all from the year 2020.


**Solution Query:**

```sql
WITH first_event as (
    SELECT   user_id,
             EXTRACT(MONTH FROM MIN(time_id)) as first_month
    FROM     events
    WHERE    EXTRACT(YEAR FROM time_id) = 2020
    GROUP BY 1
),
monthly_users as (
    SELECT   EXTRACT(MONTH FROM time_id) as event_month,
             user_id
    FROM     events
    WHERE    EXTRACT(YEAR FROM time_id) = 2020
    GROUP BY 1, 2
)
SELECT   m.event_month,
         ROUND(COUNT(DISTINCT CasE WHEN f.first_month = m.event_month THEN m.user_id END) * 100.0 / 
               COUNT(DISTINCT m.user_id), 2) as new_user_share,
         ROUND(COUNT(DISTINCT CasE WHEN f.first_month < m.event_month THEN m.user_id END) * 100.0 / 
               COUNT(DISTINCT m.user_id), 2) as existing_user_share
FROM     monthly_users m JOIN first_event f ON m.user_id = f.user_id
GROUP BY 1
ORDER BY 1
```


---