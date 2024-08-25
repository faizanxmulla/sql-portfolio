-- Solution 1: using IN

SELECT   customer_id, SUM(revenue) AS revenue
FROM     adobe_transactions
WHERE    customer_id IN (
              SELECT DISTINCT customer_id 
              FROM   adobe_transactions 
              WHERE  product = 'Photoshop'
          )
         AND product != 'Photoshop' 
GROUP BY 1



-- Solution 2: using EXISTS (better practice to use instead of IN)

SELECT   customer_id, SUM(revenue) AS revenue
FROM     adobe_transactions a
WHERE    EXISTS (
              SELECT 1
              FROM   adobe_transactions b
              WHERE  product = 'Photoshop' and
                     a.customer_id = b.customer_id
          )
         AND product != 'Photoshop' 
GROUP BY 1



-- NOTE: 

-- `EXISTS` is generally faster than `IN` when dealing with large datasets because it can short-circuit and stop searching as soon as it finds a match, rather than generating and searching through a full list of values like `IN`.


-- Why `EXISTS` is preferred in this case:

-- - `EXISTS` only needs to verify the existence of a match, which is usually quicker, especially if the customer_id column is indexed.

-- - `IN` requires building a full list of customer_ids from the subquery and then searching through this list for each row in the outer query, which can be less efficient with larger datasets.