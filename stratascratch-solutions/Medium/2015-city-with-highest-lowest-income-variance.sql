WITH cte as (
    SELECT city_id, SUM(amount) as total_amount, 'March' as month
    FROM   postmates_orders
    WHERE  date(order_timestamp_utc)='2019-03-11'
    GROUP BY city_id
    
    UNION
    
    SELECT city_id, SUM(amount), 'April' as month
    FROM   postmates_orders
    WHERE  date(order_timestamp_utc)='2019-04-11'
    GROUP BY city_id
    ORDER BY city_id
)
,cte_2 as (
    SELECT   m.name, 
             MAX(CASE WHEN month='March' THEN total_amount END) -
             MAX(CASE WHEN month='April' THEN total_amount END) as amount_difference
    FROM     cte c JOIN postmates_markets m ON c.city_id=m.id
    GROUP BY m.name
)
(
SELECT   name, amount_difference
FROM     cte_2
ORDER BY amount_difference desc
LIMIT    1
)
UNION ALL
(
SELECT   name, amount_difference
FROM     cte_2
ORDER BY amount_difference
LIMIT    1
)



-- NOTE: 

-- definitely not a Medium problem. 
-- learnt some new thing about use of parentheses in case of UNION ALL/UNION when used with ORDER BY.

