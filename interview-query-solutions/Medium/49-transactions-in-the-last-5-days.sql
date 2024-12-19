WITH CTE as (
    SELECT   user_id, COUNT(distinct DATE(created_at)) as n_transactions
    FROM     bank_transactions
    WHERE    created_at BETWEEN '2020-01-01' and '2020-01-06'
    GROUP BY user_id
)
SELECT COUNT(user_id) as number_of_users
FROM   CTE
WHERE  n_transactions = 5