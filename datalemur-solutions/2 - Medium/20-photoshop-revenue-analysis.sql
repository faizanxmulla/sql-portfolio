SELECT   customer_id, SUM(revenue) AS revenue
FROM     adobe_transactions
WHERE    product != 'Photoshop' AND
         customer_id IN (
              SELECT DISTINCT customer_id 
              FROM adobe_transactions 
              WHERE product = 'Photoshop')
GROUP BY 1