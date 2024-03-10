-- Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.


-- Solution 1: using subquery

SELECT user_id,
       spend,
       transaction_date
FROM   (SELECT user_id,
               spend,
               transaction_date,
               Rank()
                 OVER(
                   partition BY user_id
                   ORDER BY transaction_date) AS transaction_rank
        FROM   transactions) ranked_transactions
WHERE  transaction_rank = 3  



-- Solution 2: using CTE

WITH ranked_transactions AS (
    SELECT user_id, 
           spend, 
           transaction_date, 
           RANK() OVER(
                    PARTITION BY user_id 
                    ORDER BY transaction_date) as transaction_rank
    FROM transactions
)

SELECT user_id, spend, transaction_date
FROM   ranked_transactions
WHERE  transaction_rank = 3



-- remarks: YT link for window functions: https://www.youtube.com/watch?v=Ww71knvhQ-s
