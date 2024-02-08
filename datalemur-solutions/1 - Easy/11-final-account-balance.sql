SELECT account_id,
       Sum(CASE
             WHEN transaction_type = 'Deposit' THEN amount
             ELSE -amount
           END) AS final_balance
FROM     transactions
GROUP BY 1;