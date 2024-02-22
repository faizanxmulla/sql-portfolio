-- As a data analyst on the Oracle Sales Operations team, you are given a list of salespeople’s deals, and the annual quota they need to hit.

-- Write a query that outputs each employee id and whether they hit the quota or not ('yes' or 'no'). Order the results by employee id in ascending order.

-- Definitions:
--  - deal_size: Deals acquired by a salesperson in the year. Each salesperson may have more than 1 deal.
--  - quota: Total annual quota for each salesperson.


SELECT   employee_id, CASE WHEN SUM(d.deal_size) > sq.quota THEN 'yes' ELSE 'no' END AS made_quota
FROM     deals d JOIN sales_quotas sq USING(employee_id)
GROUP BY 1, sq.quota 
ORDER BY 1



-- my approach:

-- emp id, yes/no
-- order by : 1 asc

SELECT   employee_id, CASE WHEN SUM(d.deal_size) > sq.quota THEN 'yes' ELSE 'no' END AS made_quota
FROM     deals d JOIN sales_quotas sq USING(employee_id)
GROUP BY 1, 2
ORDER BY 1


-- remarks: slight mistake --> aggregate functions are "NOT ALLOWED" in GROUP BY.