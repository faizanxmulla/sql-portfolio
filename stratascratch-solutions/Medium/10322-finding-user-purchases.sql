-- Solution 1: using LAG() window function

WITH cte as (
    SELECT *, LAG(created_at) OVER(PARTITION BY user_id ORDER BY created_at) as prev_sale_date
    FROM   amazon_transactions
)
SELECT distinct user_id
FROM   cte
WHERE  created_at - prev_sale_date <= 7



-- Solution 2: using SELF-JOIN

SELECT distinct(a.user_id)
FROM   amazon_transactions a JOIN amazon_transactions b
ON     a.user_id = b.user_id
       and a.id <> b.id 
       and b.created_at BETWEEN a.created_at and a.created_at + INTERVAL '7 day' ;