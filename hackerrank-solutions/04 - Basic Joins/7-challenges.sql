-- Julia asked her students to create some coding challenges. 

-- Write a query to print the hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. 

-- If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.



WITH CTE as
(SELECT hacker_id, h.name as name, COUNT(c.challenge_id) as cnt
FROM 
    Hackers h JOIN Challenges c USING(hacker_id)
GROUP BY 
    1, 2)

SELECT hacker_id, name, cnt
FROM CTE
WHERE cnt = (
    SELECT MAX(cnt)
    FROM CTE
)
OR
cnt IN (
    SELECT cnt
    FROM CTE
    GROUP BY cnt
    HAVING COUNT(cnt) = 1
)

ORDER BY 3 DESC, 1




-- initial approach: couldn't figure the out on how to solve the last statement of the problem. 

-- hacker_id, name, COUNT(challenge_id)
-- order by : 3, 1
-- if count < max(challenge_id). 

SELECT hacker_id, h.name, COUNT(c.challenge_id) as count
FROM 
    Hackers h JOIN Challenges c USING(hacker_id)
GROUP BY 
    1, 2
-- HAVING
ORDER BY 
    3 DESC, 1
