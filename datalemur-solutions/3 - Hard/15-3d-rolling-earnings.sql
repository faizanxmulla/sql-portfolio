-- Write a query to obtain all of the users' rolling 3-day earnings. 
-- Output the user ID, transaction date and rolling 3-day earnings.


WITH daily_transactions AS (
    SELECT   user_id,
             transaction_date,
             SUM(amount) AS total_earnings
    FROM     user_transactions
    GROUP BY 1, 2
)
SELECT user_id,
       transaction_date,
       SUM(total_earnings) OVER (PARTITION BY user_id
                                 ORDER BY transaction_date
                                 RANGE BETWEEN INTERVAL '2 days' PRECEDING AND CURRENT ROW
                            ) AS rolling_3d_earnings
FROM   daily_transactions



-- my initial approach: 

WITH last_3days_cte AS (
    SELECT   *,
            LAG(transaction_date) OVER(PARTITION BY user_id
                                       ORDER BY transaction_date) as prev_date,
            LAG(transaction_date, 2) OVER(PARTITION BY user_id
                                          ORDER BY transaction_date) as prev_2_date
    FROM     user_transactions
    ORDER BY user_id, transaction_date
)
SELECT user_id, 
       transaction_date, 
       SUM(amount) OVER(PARTITION BY user_id
                        ORDER BY transaction_date) as running_total
FROM   last_3days_cte