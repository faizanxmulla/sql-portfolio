-- Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.


-- Solution 1 (as well as first approach): 

SELECT   EXTRACT(month FROM submit_date::DATE) as mth, product_id as product, ROUND(AVG(stars), 2) as avg_stars 
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2