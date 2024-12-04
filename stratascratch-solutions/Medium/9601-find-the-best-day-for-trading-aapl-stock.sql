WITH get_avg_metrics as (
    SELECT   EXTRACT(DAY FROM date) as day_of_month, 
             AVG(open) as avg_open, 
             AVG(close) as avg_close
    FROM     aapl_historical_stock_price
    GROUP BY 1
)
,ranked_prices as (
    SELECT *, RANK() OVER(ORDER BY (avg_close-avg_open) desc) as rn
    FROM   get_avg_metrics
    WHERE  avg_close-avg_open > 0
)
SELECT day_of_month, avg_open, avg_close
FROM   ranked_prices
WHERE  rn=1



-- NOTE: solved on second attempt; initially was just doing group by 'date' and NOT 'day_of_month'.