WITH ranked_loans as (
    SELECT user_id, balance, RANK() OVER(PARTITION BY user_id ORDER BY created_at desc) as rn
    FROM   loans l JOIN submissions s ON l.id=s.loan_id
    WHERE  type='Refinance'
)
SELECT user_id, balance
FROM   ranked_loans
WHERE  rn=1



-- note: could also  have done --> MAX(created_at) OVER(PARTITION BY user_id, Type)