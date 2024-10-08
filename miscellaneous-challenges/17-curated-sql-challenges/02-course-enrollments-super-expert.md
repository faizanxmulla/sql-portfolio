### Problem Statement

You have three tables: `students`, `courses`, and `enrollments`.

* The `students` table stores information about individual students.

* The `courses` table contains details about available courses.

* The `enrollments` table records the relationship between students and courses.



### Super Expert

Identify patterns in student performance across different courses and the factors that influence them. 

Recommend strategies for implementing a personalized learning path system to improve overall student success rates.

---

### Data Analysis

a. **Overall Course Completion and Performance**

```sql
SELECT COUNT(*) as total_enrollments,
       COUNT(completion_date) as completed_courses,
       ROUND(AVG(final_grade), 2) as average_grade,
       ROUND(COUNT(completion_date) * 100.0 / COUNT(*), 2) as completion_rate
FROM   enrollments
```

Result set:

total_enrollments |	completed_courses |	average_grade |	completion_rate |
--|--|--|--|
30 |	23 |	87.67 |	76.67 |

---

b. **Performance by Course Difficulty**

```sql
SELECT   c.difficulty_level,
         COUNT(*) as total_enrollments,
         ROUND(AVG(e.final_grade), 2) as average_grade,
         ROUND(COUNT(e.completion_date) * 100.0 / COUNT(*), 2) as completion_rate
FROM     enrollments e JOIN courses c USING(course_id)
GROUP BY 1
```

Result Set:

difficulty_level |	total_enrollments |	average_grade |	completion_rate |
--|--|--|--|
Beginner |	11 |	88.17 |	54.55 |
Advanced |	9 |	85.29 |	77.78 |
Intermediate |	10 |	89.05 |	100.00 |


---

c. **Category Analysis**

```sql
SELECT   c.category,
         COUNT(*) as total_enrollments,
         ROUND(AVG(e.final_grade), 2) as average_grade,
         ROUND(COUNT(e.completion_date) * 100.0 / COUNT(*), 2) as completion_rate
FROM     enrollments e JOIN courses c USING(course_id)
GROUP BY 1
ORDER BY 3 DESC
```

Result Set:


| Category              | Total Enrollments | Average Grade | Completion Rate |
|----------------------|-------------------|---------------|------------------|
| AI & ML              | 1                 | null          | 0.00             |
| Database             | 3                 | null          | 0.00             |
| Blockchain           | 1                 | null          | 0.00             |
| Quantum Computing     | 1                 | 93.00         | 100.00           |
| Cloud Computing       | 4                 | 89.00         | 100.00           |
| Web Development       | 3                 | 88.50         | 66.67            |
| Programming          | 7                 | 88.25         | 85.71            |
| Data Science         | 6                 | 87.75         | 100.00           |
| Security             | 4                 | 83.63         | 100.00           |

---

d. **Student Age Impact Analysis**

```sql
WITH student_age AS (
    SELECT student_id,
            EXTRACT(YEAR FROM AGE('2024-01-01', date_of_birth)) AS age
    FROM   students
)
SELECT   CASE 
            WHEN age < 20 THEN 'Under 20'
            WHEN age < 25 THEN '20-24'
            ELSE '25 and above'
         END AS age_group,
         COUNT(DISTINCT e.student_id) AS num_students,
         ROUND(AVG(e.final_grade), 2) AS avg_grade,
         ROUND(COUNT(e.completion_date) * 100.0 / COUNT(*), 2) AS completion_rate
FROM     student_age sa JOIN enrollments e USING(student_id)
GROUP BY 1
```

Result Set:

age_group |	num_students |	avg_grade |	completion_rate |
--|--|--|--|
20-24 |	8 |	86.33 |	75.00 |
25 and above |	12 |	88.54 |	77.78 |


---

e. **Multiple Course Enrollment Analysis**

```sql
WITH student_courses AS (
  SELECT   student_id, COUNT(*) as num_courses
  FROM     enrollments
  GROUP BY 1
)
SELECT   sc.num_courses,
         COUNT(DISTINCT sc.student_id) as num_students,
         ROUND(AVG(e.final_grade), 2) as avg_grade
FROM     student_courses sc JOIN enrollments e USING(student_id)
GROUP BY 1
ORDER BY 1
```


Result set: 

num_courses |	num_students |	avg_grade |
--|--|--|
1 |	10 |	87.86 |
2 |	10 |	87.59 |

---
---

## Key Findings

1. **Overall Performance**
   - 76.67% completion rate across all courses

   - High average grade of 87.67 for completed courses

   - 7 out of 30 enrollments are still in progress


2. **Course Difficulty Insights**

   - Intermediate courses show 100% completion rate with highest average grade (89.05)

   - Advanced courses have 77.78% completion rate with slightly lower grades (85.29)

   - Beginner courses surprisingly have lowest completion rate (54.55%) despite good grades (88.17)


3. **Category Performance**
   - Perfect completion rates in Quantum Computing, Cloud Computing, Data Science, and Security

   - Programming courses show strong performance (85.71% completion, 88.25 average grade)

   - Web Development has lower completion rate (66.67%) despite good grades (88.50)

   - Some categories (AI & ML, Database, Blockchain) have no completions yet


4. **Age Impact**

   - Older students (25 and above) slightly outperform younger ones:
     - Higher completion rate (77.78% vs 75.00%)
     - Better average grades (88.54 vs 86.33)

   - Both age groups show strong overall performance

5. **Course Load Analysis**

   - Equal split between students taking one course (10) and two courses (10)

   - Minimal difference in average grades between single-course (87.86) and two-course (87.59) students


---
---


### Recommendations for Personalized Learning Path System

**1. Fix the Beginner Course Problem**

Looking at the data, I noticed beginner courses have only a 54.55% completion rate, which seems really low. Some ideas to fix this:

- Maybe the courses are too long? We could split them into shorter parts

- Since people who complete the courses get good grades (88.17 average), maybe we need to focus on keeping them motivated.

- We could try asking the intermediate students (who have a 100% completion rate!) to help out beginners

---

**2. Make Course Difficulty More Gradual**

The data shows a weird jump:

- Beginner courses: 54.55% completion
- Intermediate courses: 100% completion
- Advanced courses: 77.78% completion

This suggests:

- We might need some "in-between" content to help people move up levels

- Maybe start with really short, simple modules in beginner courses


---


**3. Look at Course Categories**

The data shows some interesting category patterns:

- Some categories (like Cloud Computing and Data Science) have 100% completion

- Web Development only has 66.67% completion
- AI & ML, Database, and Blockchain have 0% completion (though this might be because they're newLY introduced)

We could:

- Figure out why Web Development has lower completion rates

- Maybe copy what works in the high-completion categories

- Check if we need to change or remove the categories with no completions


---

**4. Consider Age Differences**

The data shows age might matter:

- 20-24 age group: 75% completion rate, 86.33 average grade

- 25+ age group: 77.78% completion rate, 88.54 average grade

Suggestions:

- Maybe offer some extra help to the 20-24 group.

- Further analyze data by creating more age buckets

---

**5. Think About Course Load**

Our data shows:

- Students taking 1 course: 87.86 average grade

- Students taking 2 courses: 87.59 average grade

Since the grades are almost the same, we could:
- Tell students it's okay to take 2 courses if they want

- Maybe suggest which courses work well together (*)


