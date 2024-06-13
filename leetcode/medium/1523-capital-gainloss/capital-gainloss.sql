WITH price_cte AS (
    SELECT stock_name, 
            CASE WHEN operation='Buy' THEN -price 
                ELSE price
            END AS adjusted_price
    FROM   Stocks
)
SELECT   stock_name, SUM(adjusted_price) AS capital_gain_loss
FROM     price_cte
GROUP BY 1
ORDER BY 1, 2