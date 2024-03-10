-- A Microsoft Azure Supercloud customer is defined as a company that purchases at least one product from each product category.

-- Write a query that effectively identifies the company ID of such Supercloud customers.



-- Solution : 

WITH supercloud_customers AS (
    SELECT customer_id
    FROM (
        SELECT   customer_id, 
                 COUNT(DISTINCT product_category) AS category_count
        FROM     customer_contracts cc JOIN products p USING (product_id)
        GROUP BY 1
    ) x
    WHERE category_count = (SELECT COUNT(DISTINCT product_category) 
                            FROM   products)
)
SELECT customer_id
FROM   supercloud_customers



-- my approach: wasn't sure on how to add "category_count".

WITH supercloud_customers as (
  SELECT   customer_id, 
           product_category,
           count(product_id)
  FROM     customer_contracts cc JOIN products p USING(product_id)
  GROUP BY 1, 2
  ORDER BY 1, 2
)
SELECT customer_id
FROM   supercloud_customers



-- remarks: