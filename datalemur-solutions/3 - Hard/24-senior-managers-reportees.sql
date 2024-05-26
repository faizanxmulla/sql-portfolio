-- Assume we have a table of Google employees with their corresponding managers.

-- A manager is an employee with a direct report. A senior manager is an employee who manages at least one manager, but none of their direct reports is senior managers themselves. Write a query to find the senior managers and their direct reports.

-- Output the senior manager's name and the count of their direct reports. The senior manager with the most direct reports should be the first result.

-- Assumption:
-- An employee can report to two senior managers.

-- employees Table:

-- Column Name	Type
-- emp_id	integer
-- manager_id	integer
-- manager_name	string

-- employees Example Input:

-- emp_id	manager_id	manager_name
-- 1	101	Duyen
-- 101	1001	Rick
-- 103	1001	Rick
-- 1001	1008	John

-- Example Output:

-- manager_name	direct_reportees
-- Rick	1

-- Explanation:
-- Rick is a senior manager who has one manager directly reporting to him, which is employee id 101.




SELECT   m.manager_name, COUNT(m.emp_id) as direct_reportees
FROM     employees e JOIN employees m ON m.emp_id=e.manager_id
					 JOIN employees sm ON sm.emp_id=m.manager_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1