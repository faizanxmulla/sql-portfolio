-- Solution 1: using MAX() function

WITH ranked_employees as (
    SELECT id
           ,first_name
           ,last_name
           ,salary
           ,MAX(id) OVER(PARTITION BY first_name, last_name) as max_id
    FROM   employees
)
SELECT first_name, last_name, salary
FROM   ranked_employees
WHERE  id=max_id


-- Solution 2: using FIRST_VALUE() window function --> best solution

SELECT DISTINCT first_name
       ,last_name
       ,FIRST_VALUE(salary) OVER(PARTITION BY first_name, last_name ORDER BY id DESC) AS salary
FROM   employees


-- Solution 3: using RANK() window function
-- i was actually trying to do this in my attempt, but didnt notice ORDER BY was DESC.

WITH ranked_employees as (
    SELECT *, RANK() OVER(PARTITION BY first_name, last_name ORDER BY id desc) as rn
    FROM   employees
)
SELECT first_name, last_name, salary
FROM   ranked_employees
WHERE  rn=1



-- my attempt: 

WITH ranked_employees as (
    SELECT *, RANK() OVER(PARTITION BY first_name, last_name ORDER BY id) as rn
    FROM   employees
),
max_rank_cte as (
    SELECT first_name, last_name, salary, MAX(rn) as max_rank
    FROM   ranked_employees
    GROUP BY 1, 2, 3
)
SELECT first_name, last_name, salary
FROM   max_rank_cte