### Problem Statement

Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. 

If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

**Problem Link**: [Hackerrank - Hard](https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem)


### Schema Setup

```sql
CREATE TABLE hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE submissions (
    submission_date DATE,
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    score INT
);


INSERT INTO hackers (hacker_id, name) VALUES
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');

INSERT INTO submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 15),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);
```



### Expected Output

| submission_date | total_unique_submissions | max_submissions_hacker_id | max_submissions_hacker_name |
|-----------------|---------------|-----------|-------------|
| 2016-03-01      | 4             | 20703     | Angela      |
| 2016-03-02      | 2             | 79722     | Michael     |
| 2016-03-03      | 2             | 20703     | Angela      |
| 2016-03-04      | 2             | 20703     | Angela      |
| 2016-03-05      | 1             | 36396     | Frank       |
| 2016-03-06      | 1             | 20703     | Angela      |


### Solution Query


```sql
WITH submissions_ranked as (
	SELECT submission_date, hacker_id, COUNT(*) AS submissions_count, DENSE_RANK() OVER(ORDER BY submission_date) as day_number
	FROM   submissions
	GROUP BY 1, 2
),
cumulative_submissions as (
	SELECT   *, 
	         COUNT(*) OVER(PARTITION BY hacker_id ORDER BY submission_date) as till_date_submissions, 
	         CASE WHEN day_number=COUNT(*) OVER(PARTITION BY hacker_id ORDER BY submission_date) THEN 1 ELSE 0 END as flag
	FROM     submissions_ranked
	ORDER BY 1, 2
),
ranked_submissions_per_day as (
	SELECT *, 
		   SUM(flag) OVER(PARTITION BY submission_date) AS unique_submissions, 
		   ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY submissions_count desc, hacker_id) as rn
	FROM   cumulative_submissions 
)
SELECT submission_date, 
       unique_submissions, 
	   hacker_id as max_submissions_hacker_id, 
	   name as max_submissions_hacker_name
FROM   ranked_submissions_per_day rs JOIN hackers h USING(hacker_id)
WHERE  rn=1


-- NOTE: one of the most satisfying problems I have ever solved.
```