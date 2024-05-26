-- Assume you're given a table containing information about Wayfair user transactions for different products. 

-- Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

-- The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.





-- each product --> group by product_id
-- year asc order, pdt_id, current year spend, prev year spend, YOY growth round 2

-- YOY growth = Current Year Earnings — Last Year’s Earnings) / Last Year’s Earnings x 100


with CTE as (
    SELECT *, 
           EXTRACT(YEAR from transaction_date) as current_year, 
           LAG(spend) over(partition by product_id order by EXTRACT(YEAR from transaction_date)) as prev_year_spend
    FROM   user_transactions
)
SELECT current_year,
       product_id, 
       spend as curr_year_spend,
       prev_year_spend,
       ROUND(100.0 * (spend - prev_year_spend) / prev_year_spend, 2) as yoy_rate
FROM   CTE 



-- remarks: was not able to figure out on how to get the prev year --> had to do : partition by product_id