-- In an effort to identify high-value customers, Amazon asked for your help to obtain data about users who go on shopping sprees. 

-- A shopping spree occurs when a user makes purchases on 3 or more consecutive days.

-- List the user IDs who have gone on at least 1 shopping spree in ascending order.

-- transactions Table:

-- Column Name	Type
-- user_id	integer
-- amount	float
-- transaction_date	timestamp

-- transactions Example Input:

-- user_id	amount	transaction_date
-- 1	9.99	08/01/2022 10:00:00
-- 1	55	08/17/2022 10:00:00
-- 2	149.5	08/05/2022 10:00:00
-- 2	4.89	08/06/2022 10:00:00
-- 2	34	08/07/2022 10:00:00

-- Example Output:
-- user_id
-- 2

-- Explanation
-- In this example, user_id 2 is the only one who has gone on a shopping spree.



WITH CTE AS (
SELECT user_id,
       transaction_date,
       LAG(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) prev_date,
       LEAD(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) next_date
FROM   transactions
WHERE  user_id IN (
        SELECT   user_id 
        FROM     transactions 
        GROUP BY 1 
        HAVING   COUNT(transaction_date) >= 3
    ))
SELECT user_id
FROM   CTE
WHERE  EXTRACT(DAY FROM (next_date-prev_date)) >= 1