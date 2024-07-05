## Solutions

### Q1. **Average Rating per Teacher per Session**
   Calculate the average rating given by students to each teacher for each session, including the batch name.

```SQL
SELECT   a.session_id, 
	     b.name AS batch, 
	     u.name AS teacher_name,
         ROUND(AVG(rating)::numeric, 2) AS avg_rating       
FROM     attendances a JOIN sessions s ON a.session_id=s.id
                       JOIN batches b ON s.batch_id=b.id
                       JOIN users u ON u.id=s.conducted_by
GROUP BY 1, 2, 3
ORDER BY 1
```

---

### Q2. **Attendance Percentage per Session per Batch**
   Find the attendance percentage for each session for each batch, including the batch name and the user name of the session conductor.


```SQL
WITH total_students_per_batch AS (
	SELECT   batch_id, COUNT(1) AS students_per_batch
	FROM     student_batch_maps
	WHERE    active=True
	GROUP BY 1
),
changed_batch_students AS (
	SELECT cu.user_id as student_id, 
		   cu.batch_id as current_batch, 
		   pr.batch_id as prev_batch
	FROM   student_batch_maps cu JOIN student_batch_maps pr USING(user_id)
	WHERE  cu.active=True AND pr.active=False
),
students_present_per_session AS (
	SELECT   session_id, COUNT(1) AS students_per_session
    FROM     attendances a JOIN sessions s ON s.id=a.session_id
	WHERE    (a.student_id, s.batch_id) NOT IN (
	                SELECT student_id, prev_batch
	                FROM   changed_batch_students
				)  
	GROUP BY 1
	ORDER BY 1
)
SELECT s.id as session_id, 
	   b.name as batch_name,
       ROUND((students_per_session::decimal / students_per_batch) * 100.0, 2) as attendance_percentage
FROM   sessions s JOIN total_students_per_batch USING(batch_id)
                  JOIN students_present_per_session sp ON s.id=sp.session_id
	              JOIN batches b ON b.id=s.batch_id
	              JOIN users u ON u.id=s.conducted_by

```

---

### Q3. **Average Marks per Student**
   Calculate the average marks scored by each student in all the tests they appeared in.

```SQL
SELECT   student_id, AVG(marks_obtained) AS avg_marks
FROM     test_scores
GROUP BY 1
ORDER BY 1
```

---

### Q4. **Students Passed per Test**
   Identify the number of students who passed each test (scoring 40% or more), including the batch name for each test.

```SQL
SELECT   ts.test_id, b.name AS batch_name, COUNT(ts.student_id) AS passed_students_count
FROM     test_scores ts JOIN tests t ON t.id=ts.test_id 
						JOIN batches b ON t.batch_id=b.id 
WHERE    ts.marks_obtained > 0.4*total_marks
GROUP BY 1, 2
ORDER BY 1
```

---

### Q5. **Attendance Percentage for Past Batch**
   Determine each student's attendance percentage for all sessions of their past batch, considering their active periods and transfer limits.

```SQL
WITH total_students_per_batch AS (
	SELECT   batch_id, sbm.user_id AS student_id, COUNT(1) AS students_per_batch
	FROM     student_batch_maps sbm JOIN sessions s USING(batch_id)
	WHERE    active=False
	GROUP BY 1, 2
	ORDER BY 1, 2
),
changed_batch_students AS (
	SELECT cu.user_id as student_id, 
		   cu.batch_id as current_batch, 
		   pr.batch_id as prev_batch
	FROM   student_batch_maps cu JOIN student_batch_maps pr USING(user_id)
	WHERE  cu.active=True AND pr.active=False
),
students_present_per_session AS (
	SELECT   session_id, student_id, COUNT(1) AS students_per_session
    FROM     attendances a JOIN sessions s ON s.id=a.session_id
	WHERE    (a.student_id, s.batch_id) IN (
	                SELECT student_id, prev_batch
	                FROM   changed_batch_students
				)  
	GROUP BY 1, 2
	ORDER BY 1, 2
)
SELECT DISTINCT u.name as student_name,
       ROUND((COALESCE(students_per_session, 0)::decimal / students_per_batch) * 100.0, 2) as attendance_percentage
FROM   total_students_per_batch ts LEFT JOIN students_present_per_session sp USING(student_id)
									JOIN users u ON u.id=ts.student_id


```

---
---

### *Additional Questions*

### Q6. **Average Percentage Marks per Student**
   Calculate the average percentage of marks scored by each student in all tests they appeared in.

```SQL
SELECT   student_id, u.name AS student_name, AVG(marks_obtained) AS avg_marks
FROM     test_scores ts JOIN users u ON u.id=ts.student_id
GROUP BY 1, 2
ORDER BY 1
```

---

### Q7. **Percentage of Students Passed per Test**
   Determine the percentage of students who passed each test (scoring 40% or more), including the batch name for each test.

```SQL
WITH passed_students AS (
	SELECT   ts.test_id, b.name as batch_name, COUNT(student_id) AS students_passed
	FROM     tests t JOIN batches b ON t.batch_id=b.id
		             JOIN test_scores ts ON t.id=ts.test_id
		             JOIN users u ON u.id=ts.student_id
	WHERE    marks_obtained > 0.4 * total_marks
	GROUP BY 1, 2
),
total_students_per_test AS (
	SELECT   test_id, COUNT(1) as total_students
	FROM     test_scores
	GROUP BY 1
)
SELECT   tsp.test_id, 
	     batch_name,
	     ROUND((students_passed::decimal / total_students::decimal) * 100.0, 2) AS pass_percentage
FROM     total_students_per_test tsp JOIN passed_students ps USING(test_id)
ORDER BY 1
```

---

### Q8. **Attendance Percentage for All Sessions**
   Calculate each student's attendance percentage for all sessions, considering batch transfers and active status.

```SQL
WITH total_sessions AS (
	SELECT   sbm.user_id AS student_id, COUNT(1) AS total_sessions_per_student
	FROM     student_batch_maps sbm JOIN sessions s USING(batch_id)
	WHERE    active=True
	GROUP BY 1
	ORDER BY 1
),
changed_batch_students AS (
	SELECT cu.user_id as student_id, 
		   cu.batch_id as current_batch, 
		   pr.batch_id as prev_batch
	FROM   student_batch_maps cu JOIN student_batch_maps pr USING(user_id)
	WHERE  cu.active=True AND pr.active=False
),
attended_sessions AS (
	SELECT   student_id, COUNT(1) AS students_per_session
    FROM     attendances a JOIN sessions s ON s.id=a.session_id
	WHERE    (a.student_id, s.batch_id) NOT IN ( 
	                SELECT student_id, prev_batch
	                FROM   changed_batch_students
				)  
	GROUP BY 1
	ORDER BY 1
)
SELECT   DISTINCT u.name as student_name,
         ROUND((COALESCE(students_per_session, 0)::decimal / total_sessions_per_student) * 100.0, 2) as attendance_percentage
FROM     total_sessions ts LEFT JOIN attended_sessions ats USING(student_id)
						   JOIN users u ON u.id=ts.student_id     
ORDER BY 1
```

---