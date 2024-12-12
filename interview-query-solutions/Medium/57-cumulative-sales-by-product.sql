-- Solution 1: using ROWS BETWEEN clause 

-- my approach
-- solved on first attempt


SELECT product_id,
       date,
       SUM(price) OVER(PARTITION BY product_id 
                       ORDER BY date
                       ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as cumulative_sum
FROM   sales



-- Solution 2: using SELF-JOIN

SELECT   s1.product_id,
         s1.date,
         SUM(s2.price) as cumulative_sum
FROM     sales s1 JOIN sales s2 ON s1.product_id = s2.product_id AND s1.date >= s2.date
GROUP BY 1, 2
ORDER BY 1, 2