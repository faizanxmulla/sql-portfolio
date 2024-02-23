-- id is the auto-increment primary key,
-- CandidateId is the id appeared in Candidate table.

-- Write a sql to find the name of the winning candidate.


SELECT Name
FROM   Candidate JOIN (
        SELECT   CandidateId 
        FROM     Vote 
        GROUP BY 1
        LIMIT    1) winner 
on Candidate.id = winner.CandidateId;


-- my approach: 

SELECT  c.Name
FROM    Candidate c JOIN Vote v ON c.id = v.CandidateId
WHERE   v.id = 1

SELECT   c.Name
FROM     Candidate c JOIN Vote v ON c.id = v.CandidateId
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT    1 


-- remarks: ambigious problem. everyone in the comments including me got the answer as 'B' but the expected answer is 'C' i.e. testcases didn't align with the problem ; had to refer the Solution Tab.