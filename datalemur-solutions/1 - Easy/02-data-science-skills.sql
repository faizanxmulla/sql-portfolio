-- Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

-- Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.


-- solution : 

SELECT   DISTINCT candidate_id
FROM     candidates
WHERE    skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY 1
HAVING   COUNT(skill)='3'
ORDER BY 1


-- first approach : 

SELECT   DISTINCT candidate_id
FROM     candidates
WHERE    skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY 1

-- REMARKS : didn't read the question properly. always see output table, if given & try to work backwards from that.
