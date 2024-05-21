-- As the Sales Operations Analyst at Oracle, you have been tasked with assisting the VP of Sales in determining 
-- the final compensation earned by each salesperson for the year. 

-- The compensation structure includes a fixed base salary, a commission based on total deals, and potential accelerators for exceeding their quota.

-- Each salesperson earns a fixed base salary and a percentage of commission on their total deals. 
-- Also, if they beat their quota, any sales after that receive an accelerator, which is just a higher commission rate applied to their commissions after 
-- they hit the quota.

-- Write a query that calculates the total compensation earned by each salesperson. 
-- The output should include the employee ID and their corresponding total compensation, sorted in descending order. 
-- In the case of ties, the employee IDs should be sorted in ascending order.

-- Assumptions:

-- A salesperson is considered to have hit their target (quota) if their total deals meet or exceed the assigned quota.
-- If a salesperson does not meet the target, their compensation package consists of the fixed base salary and a commission based on the total deals.
-- If a salesperson meets the target, their compensation package includes
-- The fixed base salary,
-- A commission on target (quota), and
-- An additional commission, including any accelerator on the remaining balance of the total deals (total deals - quota). 
-- The accelerator represents a higher commission rate for sales made beyond the quota.

-- employee_contract Table:

-- Column Name	Type
-- employee_id	integer
-- base	integer
-- commission	double
-- quota	integer
-- accelerator	double

-- employee_contract Example Input:

-- employee_id	base	commission	quota	accelerator
-- 101	60000	0.1	500000	1.5
-- 102	50000	0.1	400000	1.5

-- deals Table:

-- Column Name	Type
-- employee_id	integer
-- deal_size	integer

-- deals Example Input:

-- employee_id	deal_size
-- 101	400000
-- 101	400000
-- 102	100000
-- 102	200000

-- Example Output:

-- employee_id	total_compensation
-- 101	155000
-- 102	80000

-- Explanation:

-- For salesperson ID 101:

-- Total Compensation = Base Salary + Commission on Target + Commission on Excess Sales
-- Total Compensation = $60,000 + (10% * $500,000) + (10% * (Total Deals - Quota) * Accelerator)
-- Total Compensation = $60,000 +$50,000 + $45,000 = $155,000

-- For salesperson ID 102:

-- Total Compensation = Base Salary + Commission on Total Deals
-- Total Compensation = $50,000 + (10% * $300,000)
-- Total Compensation = $50,000 + $30,000 = $80,000



WITH sales_data AS (
  SELECT   employee_id, 
           SUM(deal_size) AS total_deals
  FROM     deals
  GROUP BY 1
),
compensation AS (
    SELECT ec.employee_id,
           ec.base_salary,
           ec.commission,
           ec.quota,
           ec.accelerator,
           CASE 
                WHEN sd.total_deals >= ec.quota THEN (ec.base_salary + (ec.commission * ec.quota) + (ec.commission * (sd.total_deals - ec.quota) * ec.accelerator))
                ELSE (ec.base_salary + (ec.commission * sd.total_deals))
           END AS total_compensation
    FROM   employee_contract ec LEFT JOIN sales_data sd USING(employee_id)
)
SELECT   employee_id, ROUND(total_compensation, 2) AS total_compensation
FROM     compensation
ORDER BY 2 DESC, 1
