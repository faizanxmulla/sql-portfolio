-- You are given one table ‘Students’ which consists of Id,Name and Birthdate of students. Write an SQL query to find for each date the number of students having their birthday on that day and their names (seperated by commas). Also the Dates should be ordered in ascending order.


SELECT   GROUP_CONCAT(Name) as Names
FROM     Students
GROUP BY BirthDate



--  REMARKS : GROUP_CONCAT() --> new function learnt and implemented.
-- reference: https://www.mysqltutorial.org/mysql-aggregate-functions/mysql-group_concat-function/