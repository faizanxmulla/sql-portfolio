-- Intuit, a company known for its tax filing products like TurboTax and QuickBooks, offers multiple versions of these products.

-- Write a query that identifies the user IDs of individuals who have filed their taxes using any version of TurboTax for three or more consecutive years. Each user is allowed to file taxes once a year using a specific product. Display the output in the ascending order of user IDs.

-- filed_taxes Table:

-- Column Name	Type
-- filing_id	integer
-- user_id	varchar
-- filing_date	datetime
-- product	varchar


-- filed_taxes Example Input:

-- filing_id	user_id	filing_date	product
-- 1	1	4/14/2019	TurboTax Desktop 2019
-- 2	1	4/15/2020	TurboTax Deluxe
-- 3	1	4/15/2021	TurboTax Online
-- 4	2	4/07/2020	TurboTax Online
-- 5	2	4/10/2021	TurboTax Online
-- 6	3	4/07/2020	TurboTax Online
-- 7	3	4/15/2021	TurboTax Online
-- 8	3	3/11/2022	QuickBooks Desktop Pro
-- 9	4	4/15/2022	QuickBooks Online


-- Example Output:

-- user_id
-- 1

-- Explanation:

-- User 1 has consistently filed their taxes using TurboTax for 3 consecutive years. 
-- User 2 is excluded from the results because they missed filing in the third year and User 3 transitioned to using QuickBooks in their third year.



-- Solution: 

WITH turbotax_cte AS (
    SELECT user_id, 
           EXTRACT(YEAR FROM filing_date) AS filing_year
    FROM   filed_taxes
    WHERE  product LIKE '%TurboTax%'
),
consecutive_years AS (
    SELECT user_id, 
           filing_year,
           LAG(filing_year, 1) OVER (PARTITION BY user_id ORDER BY filing_year) AS prev_year_1,
           LAG(filing_year, 2) OVER (PARTITION BY user_id ORDER BY filing_year) AS prev_year_2
    FROM   turbotax_cte
),
qualified_users AS (
    SELECT   user_id
    FROM     consecutive_years
    WHERE    filing_year - prev_year_1 = 1 AND 
  			 prev_year_1 - prev_year_2 = 1
    GROUP BY 1
)
SELECT   user_id
FROM     qualified_users
ORDER BY 1




-- my initial approach: (everything is correct, but doesn't checks the consecutive years condition)


WITH turbotax_cte AS (
  SELECT   user_id, 
  		   COUNT(product) as pdt_cnt, 
  		   EXTRACT(YEAR FROM MAX(filing_date)) as latest_year, 
  		   EXTRACT(YEAR FROM MIN(filing_date)) as first_year
  FROM     filed_taxes
  WHERE    product LIKE '%TurboTax%'
  GROUP BY 1
  HAVING   COUNT(product) >= 3
)
SELECT user_id
FROM   turbotax_cte
WHERE  latest_year - first_year >= 2