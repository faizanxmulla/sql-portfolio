-- CVS Health wants to gain a clearer understanding of its pharmacy sales and the performance of various products.

-- Write a query to calculate the total drug sales for each manufacturer. Round the answer to the nearest million and report your results in descending order of total sales. In case of any duplicates, sort them alphabetically by the manufacturer name.

-- Since this data will be displayed on a dashboard viewed by business stakeholders, please format your results as follows: "$36 million".


-- Solution 1:


SELECT   manufacturer, CONCAT('$', ROUND(SUM(total_sales) / 1000000) ,' million') AS sales_mil 
FROM     pharmacy_sales
GROUP BY 1
ORDER BY SUM(total_sales) DESC, 1




-- my approach: 

SELECT   manufacturer, CONCAT('$', ROUND(SUM(total_sales) / 1000000) ,' million') AS sales_mil 
FROM     pharmacy_sales
GROUP BY 1
ORDER BY 2 DESC, 1


-- remarks: was performing "ORDER BY 2" instead of "ORDER BY sum(total_sales)".