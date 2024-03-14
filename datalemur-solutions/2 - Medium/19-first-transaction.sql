with CTE as (
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date)
    FROM   user_transactions
    WHERE  spend > 50
)
SELECT COUNT(distinct user_id) as users
FROM   CTE
WHERE  rank=1