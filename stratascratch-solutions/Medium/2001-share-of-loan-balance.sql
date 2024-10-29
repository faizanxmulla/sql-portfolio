WITH CTE AS (
    SELECT loan_id, 
           rate_type, 
           balance,
           SUM(balance) OVER(PARTITION BY rate_type) AS total_balance
    FROM   submissions
)
SELECT loan_id, 
       rate_type, 
       balance, 
       100.0 * balance / total_balance AS balance_share
FROM   CTE



-- my initial approach: getting correct answer but longer approach (which it didnt need to be)

WITH CTE as (
    SELECT loan_id, 
           rate_type, 
           balance,
           SUM(balance) FILTER(WHERE rate_type='fixed') OVER(PARTITION BY rate_type) as fixed_total_balance,
           SUM(balance) FILTER(WHERE rate_type='variable') OVER(PARTITION BY rate_type) as variable_total_balance
    FROM   submissions
)
SELECT loan_id, 
       rate_type, 
       balance, 
       100.0 * balance / COALESCE(fixed_total_balance, variable_total_balance) as balance_share
FROM   CTE