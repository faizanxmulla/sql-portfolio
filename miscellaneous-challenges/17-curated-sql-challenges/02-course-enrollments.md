### Problem Statement

You have three tables: `students`, `courses`, and `enrollments`.

* The `students` table stores information about individual students.

* The `courses` table contains details about available courses.

* The `enrollments` table records the relationship between students and courses.


### Schema Setup

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    date_of_birth DATE,
    registration_date DATE
);

INSERT INTO students (student_id, first_name, last_name, email, date_of_birth, registration_date)
VALUES
    (1, 'John', 'Doe', 'johndoe@email.com', '1998-05-15', '2023-01-10'),
    (2, 'Jane', 'Smith', 'janesmith@email.com', '1997-07-22', '2023-03-05'),
    (3, 'Michael', 'Johnson', 'michaeljohnson@email.com', '2001-11-25', '2023-01-25'),
    (4, 'Emily', 'Clark', 'emilyclark@email.com', '2000-03-30', '2023-02-20'),
    (5, 'David', 'Miller', 'davidmiller@email.com', '1995-06-18', '2023-05-15'),
    (6, 'Sophia', 'Wilson', 'sophiawilson@email.com', '2002-01-10', '2023-04-10'),
    (7, 'Daniel', 'Brown', 'danielbrown@email.com', '1999-12-05', '2023-06-22'),
    (8, 'Olivia', 'Moore', 'oliviamoore@email.com', '1998-11-09', '2023-07-18'),
    (9, 'Lucas', 'Taylor', 'lucastaylor@email.com', '1996-09-13', '2023-08-05'),
    (10, 'Ava', 'Anderson', 'avaanderson@email.com', '1997-02-25', '2023-09-02'),
    (11, 'Liam', 'Harris', 'liamharris@email.com', '1995-12-05', '2023-02-10'),
    (12, 'Ethan', 'Wright', 'ethanwright@email.com', '1998-03-16', '2023-02-22'),
    (13, 'Charlotte', 'King', 'charlotteking@email.com', '2003-09-12', '2023-04-25'),
    (14, 'Amelia', 'Scott', 'ameliascott@email.com', '1999-08-19', '2023-05-30'),
    (15, 'Noah', 'Green', 'noahgreen@email.com', '1996-04-27', '2023-03-15'),
    (16, 'Mia', 'Baker', 'miabaker@email.com', '1997-07-10', '2023-06-18'),
    (17, 'Lucas', 'Rivera', 'lucasrivera@email.com', '1996-01-25', '2023-01-05'),
    (18, 'Isabella', 'Young', 'isabellayoung@email.com', '2002-11-23', '2023-07-21'),
    (19, 'Henry', 'Perez', 'henryperez@email.com', '1999-05-04', '2023-03-22'),
    (20, 'Emma', 'Lee', 'emmalee@email.com', '1998-12-13', '2023-09-15');
```

```sql
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_name VARCHAR(50),
    category VARCHAR(50),
    difficulty_level VARCHAR(20),
    weeks_duration INT,
    price DECIMAL(10,2)
);

INSERT INTO courses (course_id, course_name, instructor_name, category, difficulty_level, weeks_duration, price)
VALUES
    (101, 'Introduction to Python', 'Dr. Alan Turing', 'Programming', 'Beginner', 8, 199.99),
    (102, 'Advanced Data Science', 'Prof. Linda Lovelace', 'Data Science', 'Intermediate', 12, 299.99),
    (103, 'Web Development Fundamentals', 'Dr. Tim Berners-Lee', 'Web Development', 'Advanced', 10, 249.99),
    (104, 'Machine Learning Basics', 'Dr. Andrew Ng', 'Data Science', 'Beginner', 10, 299.99),
    (105, 'Java Programming', 'Prof. James Gosling', 'Programming', 'Intermediate', 12, 249.99),
    (106, 'Cybersecurity Essentials', 'Dr. Bruce Schneier', 'Security', 'Advanced', 8, 349.99),
    (107, 'Cloud Computing with AWS', 'Prof. Werner Vogels', 'Cloud Computing', 'Intermediate', 10, 399.99),
    (108, 'Introduction to Databases', 'Dr. Edgar Codd', 'Database', 'Beginner', 6, 199.99),
    (109, 'Data Structures in Java', 'Dr. Robert Martin', 'Programming', 'Advanced', 12, 299.99),
    (110, 'Full Stack Web Development', 'Prof. Grace Hopper', 'Web Development', 'Intermediate', 14, 399.99),
    (111, 'AI for Everyone', 'Prof. Geoffrey Hinton', 'AI & ML', 'Beginner', 8, 299.99),
    (112, 'Blockchain Fundamentals', 'Dr. Vitalik Buterin', 'Blockchain', 'Advanced', 12, 449.99),
    (113, 'Big Data Analytics', 'Prof. Jeffrey Ullman', 'Data Science', 'Intermediate', 10, 349.99),
    (114, 'Penetration Testing', 'Dr. Kevin Mitnick', 'Security', 'Advanced', 10, 399.99),
    (115, 'Quantum Computing Basics', 'Dr. Richard Feynman', 'Quantum Computing', 'Beginner', 10, 299.99),
    (116, 'DevOps with Kubernetes', 'Prof. Kelsey Hightower', 'Cloud Computing', 'Advanced', 12, 499.99);
```

```sql
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    completion_date DATE,
    final_grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, completion_date, final_grade)
VALUES
    (1001, 1, 101, '2023-02-15', '2023-05-10', 92.00),
    (1002, 2, 102, '2023-03-20', '2023-08-02', 88.00),
    (1003, 2, 101, '2023-02-01', '2023-04-12', 94.00),
    (1004, 3, 103, '2023-03-01', '2023-06-05', 85.00),
    (1005, 4, 101, '2023-02-25', '2023-05-20', 78.00),
    (1006, 5, 102, '2023-05-18', '2023-09-01', 91.00),
    (1007, 6, 104, '2023-04-12', '2023-07-18', 89.00),
    (1008, 7, 105, '2023-06-25', '2023-09-30', 95.00),
    (1009, 8, 106, '2023-07-20', '2023-10-05', 82.00),
    (1010, 9, 107, '2023-08-10', '2023-11-18', 88.00),
    (1011, 10, 108, '2023-09-05', NULL, NULL),
    (1012, 1, 102, '2023-03-10', '2023-07-05', 90.50),
    (1013, 3, 104, '2023-05-01', '2023-08-12', 83.00),
    (1014, 4, 106, '2023-06-20', '2023-09-30', 76.50),
    (1015, 5, 107, '2023-06-28', '2023-10-12', 88.50),
    (1016, 6, 108, '2023-08-15', NULL, NULL),
    (1017, 7, 109, '2023-07-20', '2023-10-29', 89.00),
    (1018, 8, 110, '2023-08-01', '2023-11-20', 92.00),
    (1019, 9, 111, '2023-09-05', NULL, NULL),
    (1020, 10, 112, '2023-10-02', NULL, NULL),
    (1021, 11, 113, '2023-04-15', '2023-08-10', 85.00),
    (1022, 12, 114, '2023-07-12', '2023-10-15', 90.00),
    (1023, 13, 115, '2023-05-08', '2023-08-25', 93.00),
    (1024, 14, 116, '2023-06-10', '2023-09-30', 88.50),
    (1025, 15, 105, '2023-03-25', '2023-07-02', 81.50),
    (1026, 16, 106, '2023-06-30', '2023-09-25', 86.00),
    (1027, 17, 107, '2023-01-20', '2023-04-25', 91.00),
    (1028, 18, 108, '2023-07-25', NULL, NULL),
    (1029, 19, 103, '2023-08-18', NULL, NULL),
    (1030, 20, 101, '2023-09-20', NULL, NULL);
```

---

## Questions + Difficulty

### a. Easy

What is the average duration (in weeks) of all courses?


#### Solution Query

```sql
SELECT AVG(weeks_duration) as avg_course_duration
FROM   courses
```

---


### b. Intermediate

Find the top 5 most popular courses each month based on the number of enrollments, including the course name and enrollment count.

#### Solution Query

```sql
WITH monthly_enrollments as (
	SELECT   EXTRACT(MONTH FROM enrollment_date) as month, 
             course_name, 
             COUNT(student_id) as student_count
	FROM     courses c JOIN enrollments e USING(course_id)
	GROUP BY 1, 2
	ORDER BY 1, 2
),
ranked_courses as (
	SELECT course_name, student_count, month, RANK() OVER(PARTITION BY month ORDER BY student_count DESC) AS rank
	FROM   monthly_enrollments
)
SELECT   month, course_name, student_count
FROM     ranked_courses
WHERE    rank <= 5
ORDER BY 3, rank;
```

---


### c. Advanced

Calculate the month-over-month growth rate of new student registrations for the past year


#### Solution Query

```sql
WITH registrations_cte as (
    SELECT   EXTRACT(MONTH FROM registration_date) as month,
             COUNT(student_id) as registered_students_count
    FROM     students
    WHERE    registration_date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY 1
)
SELECT month, 
       ROUND((registered_students_count - LAG(registered_students_count) OVER(ORDER BY month)) 
             / NULLIF(LAG(registered_students_count) OVER(ORDER BY month), 0) * 100, 2) AS mom_growth_rate_percentage
FROM   registrations_cte
```

---

### d. Expert

We have a hypothesis that students with higher grades are more likely to sign-up for another course. How would you prove or disprove this hypothesis?


#### Approach & Key Metrics

1. **Student Grades**: We'll look at students' final grades and classify them into "high-grade" and "low-grade" groups, using a threshold of 85%.

2. **Course Enrollment**: We'll check how many courses each student has enrolled in and focus on students who took more than one course.

3. **Re-enrollment Rate**: The main metric here is the re-enrollment rate for both high and low-grade groups. If students with higher grades tend to re-enroll more often, it would support our hypothesis. Otherwise, it could be disproven.



#### Solution Query

```sql
WITH student_grades AS (
    SELECT   student_id, AVG(final_grade) AS avg_grade
    FROM     enrollments
    WHERE    final_grade IS NOT NULL
    GROUP BY 1
),
enrollment_counts AS (
    SELECT   student_id, COUNT(*) AS courses_enrolled
    FROM     enrollments
    GROUP BY 1
),
categorized_students AS (
    SELECT sg.student_id,
           sg.avg_grade,
           ec.courses_enrolled,
           CASE 
               WHEN sg.avg_grade > 85 THEN 'High Grade'
               ELSE 'Low Grade'
           END AS grade_category
    FROM   student_grades sg JOIN enrollment_counts ec USING(student_id)
)
SELECT   grade_category,
         COUNT(CASE WHEN courses_enrolled > 1 THEN 1 END) AS enrolled_multiple_courses,
         COUNT(*) AS total_students,
         ROUND(COUNT(CASE WHEN courses_enrolled > 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_multiple_courses
FROM     categorized_students
GROUP BY 1
```

#### Query Output

grade_category |	enrolled_multiple_courses |	total_students |	percentage_multiple_courses |
--|--|--|--|
Low Grade |	2 |	4 |	50.00 |
High Grade |	7 |	12 |	58.33 |


---

### e. Super Expert --> separate [file](02-course-enrollments-super-expert.md)