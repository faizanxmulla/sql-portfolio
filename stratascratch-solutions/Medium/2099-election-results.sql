WITH CTE as (
    SELECT   voter, 
             COUNT(candidate) as candidates_voted_for,
             1.0 / COUNT(candidate) as actual_vote_split
    FROM     voting_results
    WHERE    candidate IS NOT NULL
    GROUP BY voter
)
SELECT   vr.candidate
FROM     CTE c JOIN voting_results vr ON c.voter=vr.voter
GROUP BY 1
ORDER BY SUM(actual_vote_split) DESC
LIMIT    1



-- NOTE: solved on first attempt