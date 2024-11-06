SELECT   p.billing_cycle, 
         s.signup_id, 
         AVG(t.amt) as avg_trans_amount
FROM     transactions t JOIN signups s ON t.signup_id=s.signup_id 
                        JOIN plans p ON s.plan_id=p.id
WHERE    transaction_start_date < '2021-03-01'::date - INTERVAL '10 month'
GROUP BY 1, 2
ORDER BY 1 DESC, 2



-- NOTE: 

-- in the WHERE clause was doing this earlier: 
-- WHERE TO_CHAR(transaction_start_date, 'YYYY-MM')::date - '2021-03'::date >= INTERVAL '10 month'