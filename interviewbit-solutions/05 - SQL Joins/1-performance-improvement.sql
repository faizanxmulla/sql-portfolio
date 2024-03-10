-- You are given a table having the marks of one student in every test (Tests are held every day). You have to output the tests in which the student has improved his performance. 

-- For a student to improve his performance he has to score more than the previous test. Given that TestIDs are in increasing order, forming a continuous sequence without any missing numbers.


-- Solution 1 : SELF JOIN

SELECT current.TestId as TestId
FROM   Tests current, Tests prev
WHERE  current.TestId = prev.TestId + 1 and current.Marks > prev.Marks


-- Solution 2: using Subquery

SELECT TestId
FROM   Tests prev
WHERE  Marks > (SELECT Marks
                FROM   Tests current
                WHERE  prev.Testid = current.Testid - 1); 


-- Solution 3: using LAG function (not working, but )

SELECT TestId
FROM   Tests
WHERE  Marks > LAG(Marks) OVER (ORDER BY TestId)



-- my initial approach : LEAD function

SELECT   LEAD(Marks) OVER (ORDER BY MARKS) as Next
FROM     Tests


-- remarks : should have thought of this on own : "current.TestId = prev.TestId + 1"
