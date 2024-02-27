-- Write an SQL query to report the Capital gain/loss for each stock.

-- The capital gain/loss of a stock is total gain or loss after buying and selling the stock one or many times.


-- Solution : 

SELECT   stock_name, 
         SUM(CASE WHEN operation='Buy' THEN -price ELSE price END) as capital_gain_loss
FROM     Stocks
GROUP BY 1



-- my attempt : 

SELECT   stock_name, 
         (SUM(price) FILTER(WHEN operation='Sell') - SUM(price) FILTER(WHEN operation='Buy')) as capital_gain_loss
FROM     Stocks
GROUP BY 1


-- remarks: 