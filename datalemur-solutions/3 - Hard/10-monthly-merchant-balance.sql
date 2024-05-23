-- Monthly Merchant Balance [Visa SQL Interview Question]

-- Say you have access to all the transactions for a given merchant account. 

-- Write a query to print the cumulative balance of the merchant account at the end of each day, with the total balance reset back to zero at the end of the month. Output the transaction date and cumulative balance.

-- transactions Table:

-- Column Name	Type
-- transaction_id	integer
-- type	string ('deposit', 'withdrawal')
-- amount	decimal
-- transaction_date	timestamp


-- transactions Example Input:

-- transaction_id	type	amount	transaction_date
-- 19153	deposit	65.90	07/10/2022 10:00:00
-- 53151	deposit	178.55	07/08/2022 10:00:00
-- 29776	withdrawal	25.90	07/08/2022 10:00:00
-- 16461	withdrawal	45.99	07/08/2022 10:00:00
-- 77134	deposit	32.60	07/10/2022 10:00:00


-- Example Output:

-- transaction_date	balance
-- 07/08/2022 12:00:00	106.66
-- 07/10/2022 12:00:00	205.16



WITH CTE AS (
SELECT transaction_id, 
  	   transaction_date,
	   EXTRACT(DAY FROM transaction_date) AS day,
  	   EXTRACT(MONTH FROM transaction_date) AS month,
       CASE WHEN type='deposit' THEN amount ELSE -amount END as revised_amount
FROM   transactions
)
SELECT   DISTINCT transaction_date, 
         SUM(revised_amount) OVER(PARTITION BY month
                                  ORDER BY day) as balance
FROM     CTE
ORDER BY 1