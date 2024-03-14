-- Write a SQL query to find the highest grade with its corresponding course for each student. 
-- In case of a tie, you should find the course with the smallest course_id. 
-- The output must be sorted by increasing student_id.


WITH ranked_marks as (
    SELECT *, RANK() OVER(PARTITION BY student_id ORDER BY grade DESC, course_id)
    FROM   Enrollments
)
SELECT student_id, course_id, grade
FROM   ranked_marks
WHERE  rank=1


-- remarks: solved on first attempt; 