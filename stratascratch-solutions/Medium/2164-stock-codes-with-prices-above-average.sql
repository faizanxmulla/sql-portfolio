WITH get_initial_prices as (
    SELECT productcode, 
           unitprice, 
           MIN(invoicedate) OVER(PARTITION BY productcode) as first_date
    FROM   online_retails
    WHERE  quantity > 0
)
,get_overall_avg as (
    SELECT productcode, 
           unitprice,
           AVG(unitprice) OVER() as overall_avg
    FROM   get_initial_prices
)
SELECT productcode, unitprice
FROM   get_overall_avg
WHERE  unitprice > overall_avg



-- NOTE: solved on first attempt

-- also could have used ROW_NUMBER() instead of MIN() & then filtered as 'WHERE rn=1' to get initial price.