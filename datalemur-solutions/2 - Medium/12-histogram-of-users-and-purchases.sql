-- Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

-- Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.



-- Solution : completed on first attempt

with most_recent_transaction as (
    SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY transaction_date desc) as rank
    FROM user_transactions
)
SELECT   transaction_date, user_id, COUNT(product_id) as purchase_count
FROM     most_recent_transaction
WHERE    rank=1
GROUP BY 1, 2
ORDER BY 1