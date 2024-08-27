### Problem Statement | [Leetcode Link](https://leetcode.com/problems/find-the-quiet-students-in-all-exams/description/)


A "quiet" student is the one who took at least one exam and didn't score neither the high score nor the low score.

**Write a solution to report the students (student_id, student_name) being "quiet" in ALL exams.**

Don't return the student who has never taken any exam. Return the result table ordered by student_id.


### Solution Query

```sql
WITH min_max_scores AS (
    SELECT   exam_id, MAX(score) AS max_score, MIN(score) AS min_score
    FROM     exams
    GROUP BY 1
),
quiet_students AS (
    SELECT   e.student_id
    FROM     exams e JOIN min_max_scores mm USING(exam_id)
    GROUP BY 1
    HAVING   MAX(CASE WHEN score = max_score OR score = min_score THEN 1 ELSE 0 END) = 0
)
SELECT   s.student_id, s.student_name
FROM     students s JOIN quiet_students qs USING(student_id)
ORDER BY 1
```

