SELECT   EXTRACT(MONTH FROM transaction_date) as month, 
         COUNT(distinct customer_id) as customers,
         COUNT(distinct transaction_id) as transactions
FROM     wfm_transactions
WHERE    transaction_date BETWEEN '2017-01-01' AND '2017-12-31'
         and sales >= 5
GROUP BY 1
ORDER BY 1



-- NOTE: solved in first attempt