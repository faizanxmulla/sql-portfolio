-- As a business analyst on the revenue forecasting team at NVIDIA, you are given a table of NVIDIA transactions in 2021.

-- Write a query to summarize the total sales revenue for each product line. The product line with the highest revenue should be at the top of the results.

-- Assumption:

-- There will be at least one sale of each product line.

-- product_info Table:

-- Column Name	Type
-- product_id	integer
-- product_name	varchar
-- product_line	varchar

-- product_info Example Input:

-- product_id	product_name	product_line
-- 1	Quadro RTX 8000	GPU
-- 2	Quadro RTX 6000	GPU
-- 3	GeForce RTX 3060	GPU
-- 4	BlueField-3	DPU

-- transactions Table:

-- Column Name	Type
-- transaction_id	integer
-- product_id	integer
-- amount	integer

-- transactions Example Input:

-- transaction_id	product_id	amount
-- 101	1	5000
-- 102	2	4200
-- 103	3	9000
-- 104	4	7000

-- Example Output:

-- product_line	total_revenue
-- GPU	18200
-- DPU	7000



-- Solution: 

SELECT   product_line, SUM(amount) as total_revenue
FROM     product_info p LEFT JOIN transactions t USING(product_id)
GROUP BY 1  
ORDER BY 2 DESC