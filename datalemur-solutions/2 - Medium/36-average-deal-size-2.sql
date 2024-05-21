-- Assuming Salesforce operates on a per user (per seat) pricing model, we have a table containing contracts data.

-- Write a query to calculate the average annual revenue per Salesforce customer in three market segments: SMB, Mid-Market, and Enterprise. 

-- Each customer is represented by a single contract. Format the output to match the structure shown in the Example Output section below.

-- Assumptions:

-- Yearly seat cost refers to the cost per seat.
-- Each customer is represented by one contract.
-- The market segments are categorized as:-
-- SMB (less than 100 employees)
-- Mid-Market (100 to 999 employees)
-- Enterprise (1000 employees or more)

-- The terms "average deal size" and "average revenue" refer to the same concept which is the average annual revenue generated per customer in each market segment.

-- contracts Table:

-- Column Name	Type
-- customer_id	integer
-- num_seats	integer
-- yearly_seat_cost	integer

-- contracts Example Input:

-- customer_id	num_seats	yearly_seat_cost
-- 2690	50	25
-- 4520	200	50
-- 4520	150	50
-- 4520	150	50
-- 7832	878	50

-- customers Table:

-- Column Name	Type
-- customer_id	integer
-- name	varchar
-- employee_count	integer (0-100,000)

-- customers Example Input:

-- customer_id	name	employee_count
-- 4520	DBT Labs	500
-- 2690	DataLemur	99
-- 7832	GitHub	878

-- Example Output:

-- smb_avg_revenue	mid_avg_revenue	enterprise_avg_revenue
-- 1250	25000	43900

-- Explanation:
-- SMB Average smb_avg_revenue: DataLemur (customer ID 2690) is classified as the only SMB customer in the example data. 
-- They have a single contract with 50 seats and a yearly seat cost of $25. 
-- Therefore, the average annual revenue is: (50 * 25) / 1 = $1,250.

-- Mid-Market Average mid_avg_revenue: DBT Labs (customer ID 4520) is the only Mid-Market customer in the example data. 
-- They have 3 contracts with a total of 500 seats and a yearly seat cost of $50. 
-- Thus, the average annual revenue is: (500 * 50) / 1 = $25,000

-- Enterprise Average enterprise_avg_revenue: GitHub (customer ID 7832) is the only Enterprise customer in the example data.
-- They have one contract with 878 seats and a yearly seat cost of $50. 
-- Therefore, the average annual revenue per Enterprise customer is: (878 * 50) / 1 = $43,900.



WITH customer_segments AS (
    SELECT   cu.customer_id,
             cu.name,
             CASE 
                 WHEN employee_count < 100 THEN 'smb'
                 WHEN employee_count > 1000 THEN 'enterprise'
                 ELSE 'mid_mrkt' 
             END AS segment,
             SUM(yearly_seat_cost * num_seats) AS total_costs
    FROM     customers cu JOIN contracts co USING(customer_id)
    GROUP BY 1, 2, 3
)
SELECT ROUND(AVG(CASE WHEN segment = 'smb' THEN total_costs END)) AS smb_avg_rev,
       ROUND(AVG(CASE WHEN segment = 'mid_mrkt' THEN total_costs END)) AS mid_mrkt_avg_rev,
       FLOOR(AVG(CASE WHEN segment = 'enterprise' THEN total_costs END)) AS enterprise_avg_rev
FROM   customer_segments

