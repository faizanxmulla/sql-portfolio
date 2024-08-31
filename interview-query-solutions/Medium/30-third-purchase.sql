WITH ranked_transactions as (
    SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY created_at, id) as rn
    FROM   transactions
)
SELECT user_id, created_at, product_id, quantity
FROM   ranked_transactions
WHERE  rn=3


-- NOTE: classic RANK problem; solved in first attempt.