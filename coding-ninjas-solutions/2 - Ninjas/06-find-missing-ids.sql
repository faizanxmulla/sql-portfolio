-- Write an SQL query to find the missing customer IDs. 

-- The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

-- Notice that the maximum customer_id will not exceed 100.

-- Return the result table ordered by ids in ascending order.



-- Solution: using recursive CTE

WITH recursive all_ids AS (
         SELECT 1 AS n
         UNION
         SELECT n+1
         FROM   all_ids
         WHERE  n <(
                    SELECT max(customer_id)
                    FROM   customers) )
  SELECT n AS ids
  FROM   all_ids
  WHERE  n NOT IN(
            SELECT customer_id
            FROM   customers)




-- my approach: did till here was then stuck; 

with cte as (
    SELECT *,
           MAX(customer_id) over() as max_id,
           MIN(customer_id) over() as min_id
    FROM   Customers
)
SELECT   customer_id
FROM     cte
WHERE    customer_id > min and customer_id < max
ORDER BY 1


-- then upon asking Claude, it gave the following solution: but this too didnt work.

with RECURSIVE cte as (
    SELECT *,
           MAX(customer_id) over() as max_id,
           MIN(customer_id) over() as min_id
    FROM   Customers
), 
number_range as (
    SELECT min_id as id
    FROM   cte
    UNION ALL 
    SELECT id + 1
    FROM   number_range
    WHERE  id < (SELECT max_id FROM cte)
)
SELECT   id as ids
FROM     number_range
WHERE    id NOT IN (SELECT customer_id FROM Customers)
ORDER BY id



-- remarks: 
-- - good tough problem; 
-- - learnt the concept of recursive CTE's;
-- - initially was thinking of ways to generate series, but couldn't come up with any.
