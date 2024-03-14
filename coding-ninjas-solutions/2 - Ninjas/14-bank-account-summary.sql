-- Codestudio Bank (CSB) helps its coders in making virtual payments. 
-- Our bank records all transactions in the table Transaction, we want to find out the current balance of all users and check wheter they have breached their credit limit (If their current credit is less than 0).

-- Write an SQL query to report.

-- - user_name
-- - user_id
-- - credit, current balance after performing transactions.  
-- - credit_limit_breached, check credit_limit ("Yes" or "No")

-- Return the result table in any order.



-- Solution: accepted solution

SELECT   u.user_id,
         u.user_name,
         u.credit + COALESCE(SUM(CASE WHEN t.paid_by = u.user_id THEN -t.amount ELSE t.amount END), 0) AS credit,
         CASE WHEN u.credit + COALESCE(SUM(CASE WHEN t.paid_by = u.user_id THEN -t.amount ELSE t.amount END), 0) < 0 THEN 'Yes' ELSE 'No' END AS credit_limit_breached
FROM     Users u LEFT JOIN Transactions t ON u.user_id IN (t.paid_by, t.paid_to)
GROUP BY u.user_id, u.user_name, u.credit
ORDER BY 1



-- Solution: wrong solution but correct approach.

WITH cte AS (
    SELECT   paid_by, SUM(CASE WHEN paid_by = trans_id THEN -amount ELSE amount END) AS net_balance
    FROM     Transactions
    GROUP BY 1
)
SELECT   u.user_id,
         u.user_name,
         COALESCE(u.credit + cte.net_balance, u.credit) AS credit,
         CASE
             WHEN COALESCE(u.credit + cte.net_balance, u.credit) < 0 THEN 'Yes'
             ELSE 'No'
         END AS credit_limit_breached
FROM     Users u LEFT JOIN cte ON u.user_id = cte.paid_by
ORDER BY 1



-- my initial approach: got stuck here.

with cte as (
    select *, 
           CASE WHEN trans_id=paid_by THEN credit+amount 
                WHEN trans_id=paid_to THEN credit-amount
            END as updated_balance
    from   Transactions
)
SELECT u.user_id, 
       u.user_name,
       updated_balance as 'credit', 
       CASE WHEN credit < 0 THEN 'Yes' ELSE 'No' END as credit_limit_breached
    
FROM   Users u JOIN Transactions t ON u.user_id=t.paid_by or u.user_id=t.paid_to




-- remarks: 