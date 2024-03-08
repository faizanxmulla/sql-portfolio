-- Assume you're given a table containing data on Amazon customers and their spending on products in different category;
-- write a query to identify the top two highest-grossing products within each category in the year 2022. 
-- The output should include the category, product, and total spend.



-- Solution 1: using RANK() window function

WITH CTE as (
  SELECT   category, 
           product, 
           SUM(spend) as total_spend, 
           RANK() OVER(PARTITION BY category ORDER BY SUM(spend) desc) as rank
  FROM     product_spend
  WHERE    EXTRACT(year from transaction_date)='2022'
  GROUP BY 1, 2
)
SELECT category, product, total_spend
FROM   CTE
WHERE  rank <=2



-- Solution 2: using ROW_NUMBER() window function


WITH CTE as (
  SELECT   category, product, SUM(spend) as total_spend
  FROM     product_spend
  WHERE    EXTRACT(year from transaction_date)='2022'
  GROUP BY 1, 2
)
SELECT category, product, total_spend
FROM   (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_spend DESC) as rn
    FROM   CTE
) x
WHERE rn<=2


-- my approach: similar to solution 1.