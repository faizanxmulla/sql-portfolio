## 9 Meta SQL Interview Questions

### 1. Average Post Hiatus

Given a table of Facebook posts, for each user who posted at least twice in 2024, write a SQL query to find the number of days between each user's first post of the year and last post of the year in the year 2024. 

Output the user and number of the days between each user's first and last post.

`posts` **Table**:

| Column Name | Type |
|-------------|------|
| user_id     | integer |
| post_id     | integer |
| post_date   | timestamp |
| post_content| text |

`posts` **Example Input:**

| user_id | post_id | post_date | post_content |
|---------|---------|-----------|--------------|
| 151652  | 599415  | 07/10/2024 12:00:00 | Need a hug |
| 661093  | 624356  | 07/29/2024 13:00:00 | Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that's gonna fly by. I miss my girlfriend |
| 004239  | 784254  | 07/04/2024 11:00:00 | Happy 4th of July! |
| 661093  | 442560  | 07/08/2024 14:00:00 | Just going to cry myself to sleep after watching Marley and Me. |
| 151652  | 111766  | 07/12/2024 19:00:00 | I'm so done with covid - need traveling ASAP! |


**Example Output:**

| user_id | days_between |
|---------|--------------|
| 151652  | 2 |
| 661093  | 21 |


**Answer:**

```sql
SELECT   user_id, MAX(post_date) - MIN(post_date) AS days_between
FROM     posts
WHERE    EXTRACT(YEAR FROM post_date)='2024'
GROUP BY 1
HAVING   COUNT(post_id) > 2
```

---

### 2. Facebook Power Users

A Facebook power user is defined as someone who posts a ton, and gets a lot of reactions on their post. For the purpose of this question, consider a Facebook power user as someone who posts at least twice a day and receives an average of 150 comments and/or reactions per post.

**Write a SQL query to return the IDs of all Facebook power users, along with the number of posts, and the average number of reactions per post.**

Use the following tables "user_post" and "post_interactions":

`user_post` **Example Input:**

| user_id | post_id | post_date |
|---------|---------|-----------|
| 1 | 1001 | 2024-09-01 |
| 1 | 1002 | 2024-09-01 |
| 2 | 1003 | 2024-09-02 |
| 2 | 1004 | 2024-09-03 |
| 1 | 1005 | 2024-09-02 |

`post_interactions` **Example Input:**

| post_id | comments | reactions |
|---------|-----------|-----------|
| 1001 | 75 | 200 |
| 1002 | 85 | 250 |
| 1004 | 60 | 90 |
| 1005 | 100 | 150 |
| 1003 | 50 | 70 |

**Answer:**

```sql
SELECT   user_id,
         COUNT(DISTINCT up.post_id) AS no_of_posts,
         ROUND(AVG(comments + reactions), 2) AS avg_interaction_per_post
FROM     user_post up JOIN post_interactions pi USING(post_id)
GROUP BY 1
HAVING   COUNT(DISTINCT up.post_id) >= 2 AND 
         AVG(comments + reactions) >= 150
```

---

### 3. Can you explain the difference between WHERE and HAVING?

The `HAVING` clause works similarly to the `WHERE` clause, but it is used to filter the groups of rows created by the `GROUP BY` clause rather than the rows of the table themselves.

For example, say you were analyzing Facebook ads data:

```sql
SELECT   region, SUM(sales)
FROM     facebook_ads
WHERE    date > '2024-01-01'
GROUP BY 1
HAVING   SUM(sales) > 500000;
```

This query retrieves the total sales from all ads in each region, and uses the `WHERE` clause to only sales made after January 1, 2024. 

The rows are then grouped by region and the `HAVING` clause filters the groups to include only those with total sales greater than $500k.

---

### 4. Active User Retention

Assume you're given a table containing information on Facebook user actions. 

**Write a SQL query to obtain number of monthly active users (MAUs) in July 2022**, including the month in numerical format "1, 2, 3".

*Hint:* An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.

`user_actions` **Table:**

| Column Name | Type |
|-------------|------|
| user_id     | integer |
| event_id    | integer |
| event_type  | string ("sign-in, "like", "comment") |
| event_date  | datetime |

`user_actions` **Example Input:**

| user_id | event_id | event_type | event_date |
|---------|-----------|------------|------------|
| 445 | 7765 | sign-in | 06/31/2022 12:00:00 |x
| 742 | 6458 | sign-in | 07/03/2022 12:00:00 |
| 445 | 3634 | like | 07/05/2022 12:00:00 |
| 742 | 1374 | comment | 07/05/2022 12:00:00 |
| 648 | 3124 | like | 07/18/2022 12:00:00 |

**Example Output:** (for June 2022)

| month | monthly_active_users |
|-------|----------------------|
| 6 | 1 |


**Answer:**

```sql
WITH user_actions_cte AS (
    SELECT user_id,
           EXTRACT(MONTH FROM event_date) AS month,
           event_date
    FROM   user_actions
    WHERE  EXTRACT(YEAR FROM event_date) = 2022 AND 
           (EXTRACT(MONTH FROM event_date) = 6 OR 
            EXTRACT(MONTH FROM event_date) = 7)
),
prev_month_cte AS (
    SELECT user_id,
           month,
           LAG(month) OVER (PARTITION BY user_id ORDER BY event_date) AS prev_month
    FROM   user_actions_cte
)
SELECT   7 AS month,
         COUNT(DISTINCT user_id) AS monthly_active_users
FROM     prev_month_cte
WHERE    month = 7 AND prev_month = 6
```

---

### 5. What's the difference between a left and right join?

In SQL, a join generally retrieves rows from multiple tables and combines them into a single result set. For an example of the difference between a left vs. right join, suppose you had a table of Facebook users and Facebook posts.

A **LEFT JOIN** retrieves all rows from the left table (in this case, the users table) and any matching rows from the right table (the posts table). If there is no match in the right table, NULL values will be returned for the right table's columns.

A **RIGHT JOIN** combines all rows from the right table (in this case, the posts table) and any matching rows from the left table (the users table). If there is no match in the left table, NULL values will be displayed for the left table's columns.



---

### 6. Facebook Friend Recommendations

Facebook wants to recommend new friends to people who show interest in attending 2 or more of the same private Facebook events.

**Notes:**

- A user interested in attending would have either 'going' or 'maybe' as their attendance status.

- Friend recommendations are unidirectional, meaning if user x and user y should be recommended to each other, the result table should have both user x recommended to user y and user y recommended to user x.

- The result should not contain duplicates (i.e., user y should not be recommended to user x multiple times).

`friendship_status` **Table:**

| Column Name | Type |
|-------------|------|
| user_a_id   | integer |
| user_b_id   | integer |
| status      | enum ('friends', 'not_friends') |


`friendship_status` **Example Input:**

| user_a_id | user_b_id | status |
|-----------|-----------|---------|
| 111 | 333 | not_friends |
| 222 | 333 | not_friends |
| 333 | 222 | not_friends |
| 222 | 111 | friends |
| 111 | 222 | friends |
| 333 | 111 | not_friends |

`event_rsvp` **Table:**

| Column Name | Type |
|-------------|------|
| user_id     | integer |
| event_id    | integer |
| event_type  | enum ('public', 'private') |
| attendance_status | enum ('going', 'maybe', 'not_going') |
| event_date  | date |


`event_rsvp` **Example Input:**

| user_id | event_id | event_type | attendance_status | event_date |
|---------|-----------|------------|-------------------|------------|
| 111 | 567 | public | going | 07/12/2022 |
| 222 | 789 | private | going | 07/15/2022 |
| 333 | 789 | private | maybe | 07/15/2022 |
| 111 | 234 | private | not_going | 07/18/2022 |
| 222 | 234 | private | going | 07/18/2022 |
| 333 | 234 | private | going | 07/18/2022 |


**Example Output:**

| user_a_id | user_b_id |
|-----------|-----------|
| 222 | 333 |
| 333 | 222 |


**Answer:**

```sql
WITH private_events AS (
    SELECT user_id, event_id
    FROM   event_rsvp
    WHERE  attendance_status IN ('going', 'maybe') AND
  		   event_type = 'private'
)
SELECT   f.user_a_id, 
  	     f.user_b_id
FROM     private_events AS events_1 JOIN private_events AS events_2
  				  ON events_1.user_id != events_2.user_id
 				  AND events_1.event_id = events_2.event_id
         JOIN friendship_status AS f
 			      ON events_1.user_id = f.user_a_id
                  AND events_2.user_id = f.user_b_id
WHERE    status = 'not_friends'
GROUP BY 1, 2
HAVING   COUNT(*) >= 2;


-- NOTE: couldnt solve on own.
```

---

### 7. Can you explain the concept of a constraint in SQL?


Constraints are just rules for your DBMS to follow when updating/inserting/deleting data.

Say you had a table of Facebook employees, and their salaries, job titles, and performance review data. Here's some examples of SQL constraints you could implement:

**NOT NULL**: This constraint could be used to ensure that certain columns in the employee table, such as the employee's first and last name, cannot contain NULL values.

**UNIQUE**: This constraint could be used to ensure that the employee ID is unique. This would prevent duplicate entries in the employee table.

**PRIMARY KEY**: This constraint could be used to combine the NOT NULL and UNIQUE constraints to create a primary key for the employee table. The employee ID could serve as the primary key.

**FOREIGN KEY**: This constraint could be used to establish relationships between the employee table and other tables in the database. For example, you could use a foreign key to link the employee ID to the department ID in a department table to track which department each employee belongs to.

**CHECK**: This constraint could be used to ensure that certain data meets specific conditions. For example, you could use a CHECK constraint to ensure that salary values are always positive numbers.

**DEFAULT**: This constraint could be used to specify default values for certain columns. For example, you could use a DEFAULT constraint to set the employee hire date to the current date if no value is provided when a new employee is added to the database.

---

### 8. Average Number of Shares per Post

As a data analyst at Facebook, you are asked to find the average number of shares per post for each user.

In the `user_posts` table, each row represents a post by a user. Each user may have zero or more posts.

In the `post_shares` table, each row represents a share of a post. Each post may have zero or more shares.

**Write a SQL query to find the average number of shares per post for each user.**

`user_posts` **Example Input:**

| post_id | user_id | post_text | post_date |
|---------|---------|-----------|-----------|
| 1 | 1 | Hello world! | 06/08/2022 00:00:00 |
| 2 | 2 | What a beautiful day! | 06/10/2022 00:00:00 |
| 3 | 1 | Hope everyone is having a good day! | 06/18/2022 00:00:00 |
| 4 | 3 | Facebook is amazing! | 07/26/2022 00:00:00 |
| 5 | 2 | Enjoying a great meal! | 07/05/2022 00:00:00 |


`post_shares` **Example Input:**

| share_id | post_id | share_date |
|----------|---------|------------|
| 1 | 1 | 06/09/2022 00:00:00 |
| 2 | 2 | 06/11/2022 00:00:00 |
| 3 | 1 | 06/19/2022 00:00:00 |
| 4 | 1 | 06/29/2022 00:00:00 |
| 5 | 3 | 07/27/2022 00:00:00 |

**Example Output:**

| user_id | avg_shares_per_post |
|---------|-------------------|
| 1 | 1.67 |
| 2 | 0.50 |
| 3 | 0.00 |


**Answer:**

```sql
WITH share_count_cte as (
    SELECT   post_id, COUNT(share_id) as share_count
    FROM     post_shares
    GROUP BY 1
    ORDER BY 1
)
SELECT   user_id, ROUND(COALESCE(AVG(share_count), 0), 2) as avg_shares_per_post
FROM     share_count_cte RIGHT JOIN user_posts USING(post_id)
GROUP BY 1
ORDER BY 1


-- NOTE: didnt perform RIGHT JOIN.
```

---

### 9. Calculate Facebook Ad Click-Through Rate

Assume you have an events table on Facebook app analytics. 

**Write a SQL query to calculate the click-through rate (CTR)** for the app in 2022 and round the results to 2 decimal places.

**Definition and note:**

- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions

- To avoid integer division, multiply the CTR by 100.0, not 100.

`events` **Table:**

| Column Name | Type |
|-------------|------|
| app_id      | integer |
| event_type  | string |
| timestamp   | datetime |

`events` **Example Input:**

| app_id | event_type | timestamp |
|--------|------------|-----------|
| 123 | impression | 07/18/2022 11:36:12 |
| 123 | impression | 07/18/2022 11:37:12 |
| 123 | click | 07/18/2022 11:37:42 |
| 234 | impression | 07/18/2022 14:15:12 |
| 234 | click | 07/18/2022 14:16:12 |

**Example Output:**

| app_id | ctr |
|--------|-----|
| 123 | 50.00 |
| 234 | 100.00 |


**Answer:**

```sql
SELECT   app_id, 
	     ROUND(100.0 * COUNT(*) FILTER (WHERE event_type='click') / 
       		           COUNT(*) FILTER (WHERE event_type='impression')
            , 2) as ctr
FROM     events
WHERE    EXTRACT(YEAR FROM timestamp)='2022'
GROUP BY 1


-- NOTE: same thing can also be implemented in the following way: 

-- SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) 
```

---