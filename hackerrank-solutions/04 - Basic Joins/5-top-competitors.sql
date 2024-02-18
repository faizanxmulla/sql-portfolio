-- Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! 

-- Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. 

-- Order your output in descending order by the total number of challenges in which the hacker earned a full score. If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.



SELECT  h.hacker_id,
        h.Name
FROM    submissions s JOIN challenges c ON s.challenge_id = c.challenge_id
                      JOIN difficulty d ON c.difficulty_level = d.difficulty_level
                      JOIN hackers h ON s.hacker_id = h.hacker_id
WHERE    s.score = d.score
GROUP BY 1, 2
HAVING   Count(s.hacker_id) > 1
ORDER BY Count(s.hacker_id) DESC,
         s.hacker_id



-- remarks: logic was correct --> messed up in the JOINS. 