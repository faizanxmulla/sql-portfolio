-- You are given 3 tables namely ‘Students’ , ‘Departments’ and ‘Jobs’.

-- Write an SQL query to find for each student their name and the date of the job offer. The output should be sorted by Department Names. Note that there might be students who did not receive a single offer, in such cases you should not include them in the output table.


SELECT   CONCAT(s.Name, ',' ,j.Date) as Offers
FROM     Students s JOIN Departments d ON s.DepartmentId=d.DepartmentId JOIN Jobs j ON s.Id=j.Id 
ORDER BY d.DepartmentName



-- my first approach: joining 3 tables wrong.

SELECT   CONCAT(s.Name, ',' ,j.Date) as Offers
FROM     Students s JOIN Departments d ON s.DepartmentId=d.DepartmentId and Studnets s JOIN Jobs j ON s.Id=j.Id 
