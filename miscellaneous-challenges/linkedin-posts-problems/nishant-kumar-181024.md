### Problem Statement

Given a table named `famous` with two columns: `user_id` and `follower_id`, where each `follower_id` represents a follower of a specific `user_id` and is also a user of the platform. 

Write a query to calculate the **famous percentage** for each user, defined as the ratio of the number of followers a user has to the total number of users on the platform.

**Company**: Meta 

**Problem Source**: [Nishant Kumar - Linkedin Post 18.10.2024](https://www.linkedin.com/posts/im-nsk_sql-facebook-meta-activity-7252936016750104578-AzOz?utm_source=share&utm_medium=member_desktop)


### Schema Setup

```sql
CREATE TABLE famous (user_id INT, follower_id INT);

INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), 
(5, 3), (11, 7), (12, 8), (13, 5), 
(13, 10), (14, 12), (14, 3), (15, 14), (15, 13);
```

### Expected Output


| user_id | famous_percentage |
|---------|-------------------|
| 1       | 15.38             |
| 2       | 7.69              |
| 5       | 15.38             |
| 11      | 7.69              |
| 12      | 7.69              |
| 13      | 15.38             |
| 14      | 15.38             |
| 15      | 15.38             |


### Solution Query

```sql  
WITH all_users as (
	SELECT user_id as users
    FROM   famous
    UNION 
    SELECT follower_id as users
    FROM   famous
),
following_cte as (
    SELECT   user_id, COUNT(follower_id) as follower_count
    FROM     famous
    GROUP BY 1
)
SELECT   user_id, 
         ROUND(100.0 * follower_count / (SELECT COUNT(users) FROM all_users), 2) as famous_percentage
FROM     following_cte
ORDER BY 1
```