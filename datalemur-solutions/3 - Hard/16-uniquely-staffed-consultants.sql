-- Uniquely Staffed Consultants [Accenture SQL Interview Questions]

-- As a Data Analyst on the People Operations team at Accenture, you are tasked with understanding how many consultants are staffed to each client, and how many consultants are exclusively staffed to a single client.

-- Write a query that displays the outputs of client name and the number of uniquely and exclusively staffed consultants ordered by client name.


-- employees Table:

-- Column Name	Type
-- employee_id	integer
-- engagement_id	integer


-- `employees` Example Input:

-- employee_id	engagement_id
-- 1001	1
-- 1001	2
-- 1002	1
-- 1003	3
-- 1004	4


-- `consulting_engagements` Table:

-- Column Name	Type
-- engagement_id	integer
-- project_name	string
-- client_name	string


-- `consulting_engagements` Example Input:

-- engagement_id	project_name	client_name
-- 1	SAP Logistics Modernization	Department of Defense
-- 2	Oracle Cloud Migration	Department of Education
-- 3	Trust & Safety Operations	Google
-- 4	SAP IoT Cloud Integration	Google


-- Example Output:

-- client_name	total_staffed	exclusive_staffed
-- Department of Defense	2	1
-- Department of Education	1	0
-- Google	2	2



WITH exclusive_employees AS (
    SELECT   employee_id
    FROM     employees e JOIN consulting_engagements AS ce USING(engagement_id)
    GROUP BY 1
    HAVING   COUNT(engagement_id) = 1
)
SELECT   ce.client_name,
         COUNT(e.employee_id) AS total_staffed,
         COUNT(ee.employee_id) AS exclusive_staffed
FROM     employees e JOIN consulting_engagements AS ce USING(engagement_id)
                     LEFT JOIN exclusive_employees ee USING(employee_id)
GROUP BY 1
ORDER BY 1



-- NOTE: for official solution refer : question 9 of https://datalemur.com/blog/advanced-sql-interview-questions