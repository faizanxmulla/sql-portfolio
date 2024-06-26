-- Solution 1:

WITH min_max_scores AS (
    SELECT   exam_id, MAX(score) AS max_score, MIN(score) AS min_score
    FROM     Exam
    GROUP BY 1
),
exam_scores AS (
    SELECT e.student_id, e.exam_id, e.score, m.max_score, m.min_score
    FROM   Exam e JOIN min_max_scores m USING(exam_id)
),
quiet_students AS (
    SELECT   student_id
    FROM     exam_scores
    GROUP BY 1
    HAVING   COUNT(CASE WHEN score = max_score OR score = min_score THEN 1 END) = 0
)
SELECT   s.student_id, s.student_name
FROM     Student s JOIN quiet_students q USING(student_id)
ORDER BY 1



-- Solution 2: 

WITH CTE AS (
    SELECT student_id
    FROM (
        SELECT *,
               MIN(score) OVER(PARTITION BY exam_id) AS least,
               MAX(score) OVER(PARTITION BY exam_id) AS most
        FROM   Exam
    ) a
    WHERE  least = score OR most = score
)
SELECT   DISTINCT student_id, student_name
FROM     Exam JOIN Student USING (student_id)
WHERE    student_id != ALL(SELECT student_id FROM CTE)
ORDER BY 1



-- my initial approach: 

WITH exam_count_cte AS (
    SELECT   *, COUNT(exam_id) OVER(PARTITION BY s.student_id) AS exam_count
    FROM     Student s JOIN Exam e USING(student_id)
    -- HAVING   COUNT(exam_id) > 1
    ORDER BY 1
),
minmax_score_cte AS (
    SELECT   exam_id, MAX(score) AS max_score, MIN(score) AS min_score
    FROM     Exam
)
SELECT student_id, student_name
FROM   exam_count_cte ecc JOIN minmax_score_cte msc USING(exam_id)
WHERE  exam_count > 1 AND score != min_score AND score != max_score 