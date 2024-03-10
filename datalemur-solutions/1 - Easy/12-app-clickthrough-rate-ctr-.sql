-- Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

-- Definition and note:

--  - Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
--  - To avoid integer division, multiply the CTR by 100.0, not 100.


-- Solution 1: (my approach too)

SELECT   app_id, 
         ROUND(100.0 * 
              COUNT(*) FILTER(WHERE event_type='click') / 
               COUNT(*) FILTER(WHERE event_type='impression'), 2) as ctr
FROM     events
WHERE    EXTRACT(year from timestamp) = '2022'
GROUP BY 1 


-- other approaches :

-- 1. using SUM(CASE)

ROUND(100.0 *
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2)  AS ctr


-- 2. using COUNT(CASE)

ROUND(100.0 *
    COUNT(CASE WHEN event_type = 'click' THEN 1 ELSE NULL END) /
    COUNT(CASE WHEN event_type = 'impression' THEN 1 ELSE NULL END), 2)  AS ctr


-- 3. using SUM(FILTER)

ROUND(100.0 *
    SUM(1) FILTER (WHERE event_type = 'click') /
    SUM(1) FILTER (WHERE event_type = 'impression'), 2) AS ctr



-- remarks : messed up the brackets.