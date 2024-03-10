SELECT   merchant_id, 
         SUM(CASE WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount ELSE 0 END) AS volume
FROM     transactions
GROUP BY 1
ORDER BY 2 DESC;