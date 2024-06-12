WITH CTE AS (
    SELECT   location,
             AVG(amt) as avg_amount,
             AVG(signup_stop_date - signup_start_date) as avg_duration
    FROM     signups s JOIN transactions t USING(signup_id)
    GROUP BY 1
)
SELECT   *, (avg_amount / avg_duration) AS ratio
FROM     CTE
ORDER BY 4 DESC




-- MY APPROACH: (too complicated for simple problem --> also gave wrong answer)

WITH avg_signups AS (
    SELECT   location, 
             signup_id, 
             AVG(signup_stop_date - signup_start_date) OVER(PARTITION BY signup_id) as avg_signup_duration
    FROM     signups
    ORDER BY 1
),
avg_transactions AS (
    SELECT   signup_id, 
             transaction_id, 
             AVG(amt) OVER(PARTITION BY transaction_id) as avg_transaction_amount
    FROM     transactions
    ORDER BY 1
)
SELECT   location, 
         avg_signup_duration, 
         avg_transaction_amount, 
         (avg_transaction_amount / avg_signup_duration) AS ratio
FROM     avg_signups s JOIN avg_transactions t USING(signup_id)
GROUP BY 1
ORDER BY 4 DESC