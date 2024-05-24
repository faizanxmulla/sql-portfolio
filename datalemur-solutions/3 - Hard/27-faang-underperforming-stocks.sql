-- Solution 1: (easy to understand)

WITH month_cte AS (
    SELECT TO_CHAR(date, 'Mon-YYYY') as mth_yr,
           ticker,
           open, 
           LAG(open) OVER(PARTITION BY ticker ORDER BY date) as prev_open
    FROM   stock_prices
),
gain_cte AS (
    SELECT mth_yr, 
           ticker, 
           CASE WHEN open > prev_open THEN 1 ELSE 0 END as gain_count
    FROM   month_cte
),
stock_cte AS (
    SELECT mth_yr,
           ticker, 
           SUM(gain_count) OVER(PARTITION BY mth_yr) as total_gains, 
           CASE 
              WHEN SUM(gain_count) OVER(PARTITION BY mth_yr)=5 AND
                   gain_count=0 
              THEN ticker ELSE NULL
           END AS underperforming_stock
    FROM   gain_cte
)
SELECT   mth_yr,
         underperforming_stock
FROM     stock_cte
WHERE    total_gains=5 AND underperforming_stock IS NOT NULL
ORDER BY 1



-- Solution 2: more compact approach: (but the same logic)

WITH cte as (
    SELECT ticker, 
           date,
           open, 
           CASE WHEN open - LAG(open) OVER (PARTITION BY ticker 
                                            ORDER BY date) > 0 THEN 1 ELSE 0 END as change
    FROM stock_prices
),
cte2 as (
    SELECT *, SUM(change) OVER(PARTITION BY date) AS sum
    FROM   cte)
SELECT   TO_CHAR(date, 'Mon-yyyy') as mth_year, ticker as underperforming_stock
FROM     cte2
WHERE    change = 0 AND sum = 5
ORDER BY 1