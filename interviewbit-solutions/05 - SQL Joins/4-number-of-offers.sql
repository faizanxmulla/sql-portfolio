-- Given 2 tables ‘Students’ and ‘Jobs’, write an SQL query to find for every student the number of offers they got in the month of November. 

-- The output should contain 1 column by the name ‘Job_Offers’ which should contain the number of jobs received by each of the student in the month of November. Also it should be sorted by the Id of the students.


SELECT   COUNT(j.Id) as Job_Offers
FROM     Students s LEFT JOIN Jobs j ON j.Id = s.Id and MONTH(Date)='11'
GROUP BY s.Id
ORDER BY s.Id


-- other approach : 
-- SELECT IFNULL(COUNT(Salary), 0) as Job_Offers