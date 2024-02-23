-- A university uses 2 data tables, student and department, to store data about its students and the departments associated with each major.

-- Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).

-- Sort your results by descending number of students; if two or more departments have the same number of students, then sort those departments alphabetically by department name.



SELECT   d.dept_name as dept_name,
         COUNT(s.student_id) as student_number
FROM     student s RIGHT JOIN department d USING(dept_id)
GROUP BY 1
ORDER BY 2 DESC, 1



-- remarks: should have RIGHT joined instead of just join to implement this condition -> even ones with no current students