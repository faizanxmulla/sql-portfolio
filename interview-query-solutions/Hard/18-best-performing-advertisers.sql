WITH total_amount_cte as (
    SELECT   transaction_date, 
             EXTRACT(WEEK FROM transaction_date) as week_number,
             advertiser_name,
             amount,
             SUM(amount) OVER(PARTITION BY EXTRACT(WEEK FROM transaction_date), advertiser_name) as total_amount 
    FROM     advertisers a JOIN revenue r USING(advertiser_id)
    ORDER BY 5 DESC
),
top_advertiser_cte as (
    SELECT   advertiser_name, week_number, MAX(total_amount) as max_amount
    FROM     total_amount_cte 
    GROUP BY 1, 2
)
SELECT   advertiser_name, transaction_date, amount
FROM     total_amount_cte am JOIN top_advertiser_cte ad 
ON       am.advertiser_name = ad.advertiser_name 
         AND am.week_number = ad.week_number 
         AND am.total_amount = ad.max_amount
ORDER BY 3 DESC



-- my attempt 

WITH CTE as (
    SELECT   transaction_date, 
             EXTRACT(WEEK FROM transaction_date) as week_number,
             advertiser_name,
             amount,
             SUM(amount) OVER(PARTITION BY EXTRACT(WEEK FROM transaction_date), advertiser_name) as total_amount 
    FROM     advertisers a JOIN revenue r USING(advertiser_id)
    ORDER BY 5 DESC
)
SELECT   advertiser_name, transaction_date, amount
FROM     CTE 
WHERE    total_amount IN (SELECT MAX(total_amount) FROM CTE)
ORDER BY 3 desc
LIMIT    3


-- NOTE: very close; the last record of 700 is getting skipped.