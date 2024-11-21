WITH CTE as (
    SELECT   driver_id, MIN(actual_delivery_time) as first_order
    FROM     delivery_orders
    WHERE    actual_delivery_time IS NOT NULL
    GROUP BY driver_id
)
SELECT 100.0 * SUM(CASE WHEN delivery_rating = 0 THEN 1 ELSE 0 END) / 
               COUNT(*) AS perc_zero_rating
FROM   CTE c JOIN delivery_orders d 
ON     c.driver_id=d.driver_id 
       and c.first_order = d.actual_delivery_time




-- my attempt: 

WITH CTE as (
    SELECT   driver_id, MIN(actual_delivery_time) as first_order
    FROM     delivery_orders
    WHERE    delivery_rating=0
             -- and actual_delivery_time IS NOT NULL
    GROUP BY driver_id
)
SELECT 100.0 * COUNT(driver_id) / (SELECT COUNT(DISTINCT driver_id) FROM delivery_orders) as perc_zero_rating
FROM   CTE



-- NOTE: 

-- wasn't doing this earlier --> and c.first_order = d.actual_delivery_time

-- also could have used FIRST_VALUE() to find the find order of each driver
