SELECT   s1.student AS one_student
         ,s2.student AS other_student
         ,ABS(s1.score - s2.score) AS score_diff
FROM     scores AS s1 JOIN scores AS s2 ON s1.id < s2.id
ORDER BY 3, 1
LIMIT    1