WITH ranked_open AS (
    SELECT TO_CHAR(date, 'Mon-YYYY') AS mth_year,
           ticker,
           open, 
           RANK() OVER(PARTITION BY ticker ORDER BY open DESC) AS open_high,
           RANK() OVER(PARTITION BY ticker ORDER BY open) AS open_low
    FROM   stock_prices
),
open_high_cte AS (
    SELECT ticker, 
           mth_year as highest_mth,
           open AS highest_open
    FROM   ranked_open
    WHERE  open_high=1
),
open_low_cte AS (
    SELECT ticker, 
           mth_year as lowest_mth,
           open AS lowest_open
    FROM   ranked_open
    WHERE  open_low=1
)   
SELECT ticker, highest_mth, highest_open, lowest_mth, lowest_open
FROM   open_high_cte h JOIN open_low_cte l USING(ticker)



-- remarks: solved on own in first attempt. 

-- NOTE: if someone wants to combine the 2 middle CTE into 1, then can do the following: 

CTE AS (
    SELECT   ticker, 
             MAX(CASE WHEN open_high = 1 THEN mth_year END) AS highest_mth,
             MAX(CASE WHEN open_high = 1 THEN open END) AS highest_open,
             MAX(CASE WHEN open_low = 1 THEN mth_year END) AS lowest_mth,
             MAX(CASE WHEN open_low = 1 THEN open END) AS lowest_open
    FROM     ranked_open
    GROUP BY 1
)