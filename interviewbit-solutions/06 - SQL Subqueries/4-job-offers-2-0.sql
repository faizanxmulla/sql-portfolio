-- You are given 3 tables namely ‘Students’ , ‘Departments’ and ‘Jobs’.

-- Write an SQL query to find sum of Distinct salaries obtained by students from ‘CSE’ department. The output should be sorted by the Department names.

-- Note: There might be students who have got multiple job offers.



SELECT   Sum(DISTINCT j.salary) AS Salary
FROM     jobs j
         JOIN students s using(id)
         JOIN departments d using(departmentid)
WHERE    d.departmentname = 'CSE'
GROUP BY d.departmentname
ORDER BY d.departmentname 