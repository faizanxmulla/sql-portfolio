-- Solution 1: (my approach)

WITH transaction_pairs AS (
    SELECT *
    FROM   transactions a JOIN transactions b USING(merchant_id, credit_card_id, amount)
    WHERE  b.transaction_timestamp <= a.transaction_timestamp + INTERVAL '10 minutes'
           AND a.transaction_timestamp < b.transaction_timestamp
)   
SELECT COUNT(*) AS payment_count
FROM   transaction_pairs


-- NOTE: 

-- did everything right; but was just forgetting this condition : 
-- a.transaction_timestamp < b.transaction_timestamp



-- Solution 2: (official site solution)

WITH payments AS (
    SELECT merchant_id, 
           EXTRACT(EPOCH FROM transaction_timestamp - 
           LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount 
                                           ORDER BY transaction_timestamp)) / 60 AS minute_difference 
    FROM   transactions
) 
SELECT COUNT(merchant_id) AS payment_count
FROM   payments 
WHERE  minute_difference <= 10