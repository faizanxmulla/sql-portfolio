SELECT   student_name
         ,SUM(CASE WHEN exam_id=1 THEN score END) AS exam_1
         ,SUM(CASE WHEN exam_id=2 THEN score END) AS exam_2
         ,SUM(CASE WHEN exam_id=3 THEN score END) AS exam_3
         ,SUM(CASE WHEN exam_id=4 THEN score END) AS exam_4
FROM     exam_scores
GROUP BY 1


-- NOTE: solved in first attempt itself.