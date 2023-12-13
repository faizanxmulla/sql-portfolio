SELECT s.student_id, s.student_name, su.subject_name, COUNT(e.student_id) as attended_exams

FROM Students s 
        JOIN Subjects su LEFT JOIN Examinations e
        ON s.student_id = e.student_id
        AND su.subject_name = e.subject_name

GROUP BY 2,3
ORDER BY 1,3