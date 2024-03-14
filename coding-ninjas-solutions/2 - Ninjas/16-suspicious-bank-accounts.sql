-- Write an SQL query to report the IDs of all suspicious bank accounts.

-- A bank account is suspicious if the total income exceeds the max_income for this account for two or more consecutive months. 
-- The total income of an account in some month is the sum of all its deposits in that month (i.e., transactions of the type 'Creditor').

-- Return the result table in ascending order by transaction_id.




WITH monthly_income
     AS (SELECT   t.account_id,
                  Extract(year FROM t.day)  AS year,
                  Extract(month FROM t.day) AS month,
                  Sum(CASE WHEN t.type_pro = 'Creditor' THEN t.amount ELSE 0 END) AS income
         FROM     transactions t
         GROUP BY 1, 2, 3),
     consecutive_income
     AS (SELECT account_id,
                year,
                month,
                income,
                Lag(income) OVER (PARTITION BY account_id ORDER BY year, month) AS prev_income
         FROM   monthly_income)
SELECT   DISTINCT ci.account_id
FROM     consecutive_income ci JOIN accounts a ON ci.account_id = a.account_id
WHERE    ci.income > a.max_income AND ci.prev_income > a.max_income
ORDER BY 1 




-- my initial approach: 

SELECT distinct a.account_id
FROM   Transactions t1 JOIN Accounts a USING(account_id)
WHERE  a.max_income < (
    SELECT SUM(amount)
    FROM   Transactions t2
    WHERE  type_pro='Creditor'
)
GROUP BY 1, EXTRACT(month from day)