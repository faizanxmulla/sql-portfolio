-- A "quiet" student is the one who took at least one exam and didn't score neither the high score nor the low score.

-- Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.
-- Don't return the student who has never taken any exam. Return the result table ordered by student_id.



WITH ranked_scores as (
    SELECT *, 
           MAX(score) OVER(PARTITION BY e.exam_id) as max,
           MIN(score) OVER(PARTITION BY e.exam_id) as min
    FROM   Student s JOIN Exam e USING(student_id)  
)

SELECT student_id, student_name
FROM   ranked_scores
WHERE  student_name NOT IN (
    SELECT student_name 
    FROM   ranked_scores
    WHERE  score=max OR score=min
)
GROUP BY 1, 2
ORDER BY 1



-- my approach : 

WITH ranked_scores as (
    SELECT *, 
           RANK() OVER(PARTITION BY e.exam_id ORDER BY e.score)
    FROM   Student s JOIN Exam e USING(student_id)  
)

SELECT student_id, student_name
FROM   ranked_scores
WHERE  score BETWEEN (
    SELECT MAX(score), MIN(score)
    FROM   ranked_scores
)
GROUP BY 1, 2
HAVING   COUNT(*) >= 1
ORDER BY 1


-- remarks: mistake of always restrciting self to traditional window functions. 