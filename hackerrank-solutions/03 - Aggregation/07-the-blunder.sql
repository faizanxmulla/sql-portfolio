-- Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.

SELECT CEIL(AVG(salary) - AVG(REPLACE(salary, '0', '')))
FROM Employees


-- REMARKS : 
-- did not read the question properly and was using ROUND instead of CEIL. 