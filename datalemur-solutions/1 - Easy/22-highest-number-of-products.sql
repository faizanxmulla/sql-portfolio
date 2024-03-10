-- Asume that you are given the table below containing information on various orders made by customers 

-- Write a query to obtain the names of the 10 customers who have ordered the highest number of products among those customers who have spend them at least $1000 total.


SELECT   user_id, COUNT(product_id) as product_count
FROM     user_transactions
GROUP BY 1
ORDER BY 2 DESC
LIMIT    10 



-- my approach: 

SELECT   user_id, COUNT(product_id) as product_count
FROM     user_transactions
WHERE    COUNT(transaction_id) IN (
        SELECT MAX()
)
GROUP BY 1
LIMIT    10 


-- remarks: got question from the book - problem 8.5