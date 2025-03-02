WITH get_total_scores as (
    SELECT   student, SUM(assignment1 + assignment2 + assignment3) as total_score
    FROM     box_scores
    GROUP BY student
)
SELECT MAX(total_score) - MIN(total_score) as difference_in_scores
FROM   get_total_scores