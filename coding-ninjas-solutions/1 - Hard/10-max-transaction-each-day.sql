-- Write an SQL query to report the IDs of the transactions with the maximum amount on their respective day. If in one day there are multiple such transactions, return all of them.

-- Return the result table in ascending order by transaction_id.


-- Solution 1: using Subquery

SELECT   transaction_id
FROM     Transactions
WHERE    amount IN (
        SELECT   MAX(amount)
        FROM     Transactions
        GROUP BY date(day)
    )
ORDER BY transaction_id


-- Solution 2: using CTE and RANK()

WITH ranked_transactions as (
    SELECT *, RANK() OVER(PARTITION BY DATE(day) ORDER BY amount desc) as rank
    FROM   Transactions
)
SELECT   transaction_id
FROM     ranked_transactions
WHERE    rank=1
ORDER BY 1



-- my approach: was missing this --> DATE(day)

SELECT   transaction_id
FROM     Transactions
WHERE    amount IN (
        SELECT   MAX(amount)
        FROM     Transactions
        GROUP BY day
    )
ORDER BY transaction_id