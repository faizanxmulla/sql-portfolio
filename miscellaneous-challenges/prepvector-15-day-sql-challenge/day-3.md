## Single vs Repeat Job Posters

### Problem Statement 

Given a table of job postings, write a query to retrieve the number of users that have posted each job only once and the number of users that have posted at least one job multiple times.


### Schema setup 

```sql
CREATE TABLE job_postings (
    id INT PRIMARY KEY,
    user_id INT,
    job_id INT,
    posted_date DATETIME
);

INSERT INTO job_postings (id, user_id, job_id, posted_date) VALUES
(1, 1, 101, '2024-01-01'),
(2, 1, 102, '2024-01-02'),
(3, 2, 201, '2024-01-01'),
(4, 2, 201, '2024-01-15'),
(5, 2, 202, '2024-01-03'),
(6, 3, 301, '2024-01-01'),
(7, 4, 401, '2024-01-01'),
(8, 4, 401, '2024-01-15'),
(9, 4, 402, '2024-01-02'),
(10, 4, 402, '2024-01-16'),
(11, 5, 501, '2024-01-05'),
(12, 5, 502, '2024-01-10');
```

### Expected Output 

single_post_users |	multiple_post_users |
--|--|
3 |	2 |


### Solution Query 

```sql
WITH cte as (
    SELECT   user_id, job_id, COUNT(*) as postings_count
    FROM     job_postings
    GROUP BY user_id, job_id
)
,cte_2 as (
    SELECT   user_id, MAX(CASE WHEN postings_count > 1 THEN 1 ELSE 0 END) as has_multiple_posts
    FROM     cte
    GROUP BY user_id
)
SELECT COUNT(*) FILTER(WHERE has_multiple_posts = 0) as single_post_users,
       COUNT(*) FILTER(WHERE has_multiple_posts = 1) as multiple_post_users
FROM   cte_2



-- my initial approach:

WITH CTE as (
    SELECT user_id, job_id, COUNT(*) as postings_count
    FROM   job_postings
    GROUP BY user_id, job_id
)
SELECT COUNT(*) FILTER(WHERE postings_count=1) as single_post_users,
       COUNT(*) FILTER(WHERE postings_count>1) as multiple_post_users
FROM   CTE
```