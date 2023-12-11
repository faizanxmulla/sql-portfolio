SELECT teacher_id, COUNT(DISTINCT subject_id) as cnt
FROM Teacher 
GROUP BY 1


# unique subjects --> DISTINCT 
# each teacher --> GROUP BY
# no need to focus on dept_id.