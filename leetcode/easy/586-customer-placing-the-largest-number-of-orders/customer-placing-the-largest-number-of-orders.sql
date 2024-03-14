SELECT   customer_number
FROM     Orders
GROUP BY 1
ORDER BY count(customer_number) desc
LIMIT    1


-- GOOD TO KNOW STUFF : 

-- Why are subqueries bad? They're good for readability and often for interviewing. However, in real life subqueries increase the amount of scans taken from the original tables.
-- From a performance tuning perspective, it's often a good idea to reduce the number of subqueries firing every second on the backend.
-- For interviews, it's often a good idea to go with the subquery.