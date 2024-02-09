-- Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as  space-separated integers.

SELECT   (salary * months) as total_salary,
         Count(*)
FROM     employee
GROUP BY 1
ORDER BY 1 DESC
LIMIT    1; 