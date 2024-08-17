WITH CTE AS (
    SELECT   TO_CHAR(created_at, 'YYYY-MM-DD') as dt,
             SUM(transaction_value) as total_deposits
    FROM     bank_transactions
    WHERE    transaction_value > 0
    GROUP BY 1
)
SELECT   dt, AVG(total_deposits) OVER(ORDER BY dt ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as rolling_three_day
FROM     CTE



-- NOTE: didn't read the rolling AVG part, so was trying to do SUM() instead.