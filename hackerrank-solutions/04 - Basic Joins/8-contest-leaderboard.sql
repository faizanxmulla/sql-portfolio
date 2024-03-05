-- The total score of a hacker is the sum of their maximum scores for all of the challenges. 

-- Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. 

-- Exclude all hackers with a total score of 0 from your result.



SELECT h.hacker_id,
       NAME,
       Sum(max) AS total_score
FROM   hackers AS h INNER JOIN (
                SELECT   hacker_id,
                         Max(score) AS max
                FROM     submissions
                GROUP BY challenge_id, hacker_id) max_score
               USING(hacker_id)
GROUP BY 1, 2
HAVING total_score > 0
ORDER BY 3 DESC, 1




-- initial approach: 

-- total_score = SUM(MAX_SCORES FOR ALL CHALLENGES)
-- hacker_id, name, and total score
-- ORDER BY: 3 DESC, 1
-- exclude : having total_score=0

SELECT   hacker_id, h.name, SUM(max(s.score)) as total_score
FROM     submissions s JOIN hackers h USING(hacker_id)
GROUP BY 1, 2
HAVING   total_score > 0
ORDER BY 3 DESC, 1


-- remarks: 