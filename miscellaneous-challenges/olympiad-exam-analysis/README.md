## Olympiad Exam Analysis

### Problem Statement

We conduct an annual Olympiad exam for our partner schools to evaluate student performance. The exam data is stored across four tables: Student_list, Student_response, Correct_answers, and Question_paper_code. The objective is to validate student responses and present a comprehensive summary in a single table using SQL.

The Learn Basics Olympiad is an objective exam with the following characteristics:

- Each question has 5 options: A, B, C, D, and E

- Only A, B, C, and D are valid answer options

- Students can choose E if they haven't learned the concept yet

We need to analyze the performance of students from Google Public School in both Math and Science subjects across different classes.

### Schema setup

```sql
CREATE TABLE student_list (
    Roll_number INT PRIMARY KEY,
    Student_name VARCHAR(100),
    Class INT,
    Section VARCHAR(1),
    School_name VARCHAR(100)
);

CREATE TABLE student_response (
    Roll_number INT,
    Question_paper_code VARCHAR(10),
    Question_number INT,
    Option_marked VARCHAR(1),
    FOREIGN KEY (Roll_number) REFERENCES student_list(Roll_number)
);

CREATE TABLE correct_answers (
    Question_paper_code VARCHAR(10),
    Question_number INT,
    Correct_option VARCHAR(1),
    PRIMARY KEY (Question_paper_code, Question_number)
);

CREATE TABLE question_paper_code (
    Question_paper_code VARCHAR(10) PRIMARY KEY,
    Class INT,
    Subject VARCHAR(20)
);
```

### Expected Output

The output should be a single table with the following columns:

| Roll_number |
--|
| Student_name |
| Class |
| Section |
| School_name |
| Math_correct |
| Math_wrong |
| Math_yet_to_learn |
| Math_score |
|  Math_percentage |
|  Science_correct |
|  Science_wrong |
|  Science_yet_learn |
|  Science_score |
|  Science_percentage |

### Solution Query

```sql
WITH student_performance AS (
    SELECT   sr.Roll_number,
             qpc.Subject,
             COUNT(CASE WHEN sr.Option_marked = ca.Correct_option THEN 1 END) AS Correct,
             COUNT(CASE WHEN sr.Option_marked != ca.Correct_option AND sr.Option_marked != 'E' THEN 1 END) AS Wrong,
             COUNT(CASE WHEN sr.Option_marked = 'E' THEN 1 END) AS Yet_to_learn,
             COUNT(CASE WHEN sr.Option_marked = ca.Correct_option THEN 1 END) * 4 AS Score,
             ROUND(COUNT(CASE WHEN sr.Option_marked = ca.Correct_option THEN 1 END) * 100.0 / COUNT(*), 2) AS   Percentage
    FROM     student_response sr JOIN correct_answers ca USING(Question_paper_code, Question_number) 
                                 JOIN question_paper_code qpc USING(Question_paper_code)
    GROUP BY 1, 2
)
SELECT   sl.Roll_number,
         sl.Student_name,
         sl.Class,
         sl.Section,
         sl.School_name,
         COALESCE(math.Correct, 0) AS Math_correct,
         COALESCE(math.Wrong, 0) AS Math_wrong,
         COALESCE(math.Yet_to_learn, 0) AS Math_yet_to_learn,
         COALESCE(math.Score, 0) AS Math_score,
         COALESCE(math.Percentage, 0) AS Math_percentage,
         COALESCE(science.Correct, 0) AS Science_correct,
         COALESCE(science.Wrong, 0) AS Science_wrong,
         COALESCE(science.Yet_to_learn, 0) AS Science_yet_learn,
         COALESCE(science.Score, 0) AS Science_score,
         COALESCE(science.Percentage, 0) AS Science_percentage
FROM     student_list sl LEFT JOIN student_performance math ON sl.Roll_number = math.Roll_number AND math.Subject = 'Math'
                         LEFT JOIN student_performance science ON sl.Roll_number = science.Roll_number AND science.Subject = 'Science'
WHERE    sl.School_name = 'Google Public School'
ORDER BY 1
```
