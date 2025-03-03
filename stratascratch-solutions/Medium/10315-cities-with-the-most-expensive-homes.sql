WITH avg_market_prices as (
    SELECT distinct city, 
           AVG(mkt_price) OVER(PARTITION BY city) as city_avg,
           AVG(mkt_price) OVER() as national_avg
    FROM   zillow_transactions
)
SELECT city
FROM   avg_market_prices
WHERE  city_avg > national_avg