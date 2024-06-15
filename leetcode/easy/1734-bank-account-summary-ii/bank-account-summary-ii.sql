SELECT   name, SUM(amount) AS balance
FROM     Users u JOIN Transactions t USING(account)
GROUP BY 1
HAVING   SUM(amount) > 10000