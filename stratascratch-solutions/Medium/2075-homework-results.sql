SELECT   s.student_firstname, 
         AVG(h.grade) as avg_grade,
         100.0 * COUNT(homework_id) FILTER(WHERE grade IS NOT NULL) / COUNT(homework_id) as completion_rate
FROM     allstate_homework h JOIN allstate_students s ON h.student_id=s.student_id
GROUP BY s.student_id, s.student_firstname



-- NOTE: solved in first attempt