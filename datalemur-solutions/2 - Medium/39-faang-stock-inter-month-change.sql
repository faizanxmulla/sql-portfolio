WITH intermonth_prices AS (
  SELECT ticker,
         date,
         close,
         LAG(close) OVER(PARTITION BY ticker ORDER BY date) AS prev_close
  FROM   stock_prices
)
SELECT   ticker,
         date,
         close,
         ROUND((close - prev_close)/prev_close*100,2) AS intermth_change_pct
FROM     intermonth_prices
ORDER BY 1, 2