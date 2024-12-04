SELECT   CONCAT('Q', EXTRACT(QUARTER FROM transaction_date)) as quarter,
         COALESCE(SUM(amount) FILTER(WHERE department='IT'), 0) as it_spending,
         COALESCE(SUM(amount) FILTER(WHERE department='HR'), 0) as hr_spending,
         COALESCE(SUM(amount) FILTER(WHERE department='Marketing'), 0) as marketing_spending,
         COALESCE(SUM(amount) FILTER(WHERE department NOT IN ('IT', 'HR', 'Marketing')), 0) as other_spending
FROM     transactions
GROUP BY 1
HAVING   COUNT(transaction_id) > 1



-- NOTE: solved on second attempt; didn't handle the NULL values initially.