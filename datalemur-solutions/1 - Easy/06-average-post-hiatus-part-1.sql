-- Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.


-- Solution 1 : 

SELECT   user_id, MAX(post_date::DATE) - MIN(post_date::DATE) as days_between
FROM     posts
WHERE    EXTRACT(year from post_date)=2021
GROUP BY 1
HAVING   COUNT(post_id) > 1



-- other ways to handle dates : 
-- 1. EXTRACT(DAY FROM (MAX(post_date) - MIN(post_date))) or EXTRACT('days' from MAX(post_date) - MIN(post_date))

-- 2. post_date BETWEEN '2021-01-01' AND '2021-12-31' or DATE_PART('year', post_date::DATE) = 2021 



-- first approach : 
-- lead to this output : "days":307,"hours":11

SELECT   user_id, MAX(post_date) - MIN(post_date) as days_between
FROM     posts
WHERE    EXTRACT(year from post_date)=2021
GROUP BY 1


-- REMARKS : "::DATE" new thing to learn. 