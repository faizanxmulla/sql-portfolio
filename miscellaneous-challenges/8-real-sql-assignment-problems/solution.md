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

```

---
---

### *Additional Questions*

### Q6. **Average Percentage Marks per Student**
   Calculate the average percentage of marks scored by each student in all tests they appeared in.

```SQL

```

---

### Q7. **Percentage of Students Passed per Test**
   Determine the percentage of students who passed each test (scoring 40% or more), including the batch name for each test.

```SQL

```

---

### Q8. **Attendance Percentage for All Sessions**
   Calculate each student's attendance percentage for all sessions, considering batch transfers and active status.

```SQL

```

---