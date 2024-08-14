### Problem Statement

1. Get the list of students who scored above the average marks in each subject.

2. Get the percentage of students who score more than 90 in any subject amongst the total students. 

3. Get the second-highest and the second-lowest marks for each subject.

4. For each student and test, identify if their marks increased or decreased from the previous test.



### Schema Setup

```sql
CREATE TABLE students (
    studentid INT,
    studentname NVARCHAR(255),
    subject NVARCHAR(255),
    marks INT,
    testid INT,
    testdate DATE
);

INSERT INTO students VALUES 
(2, 'Max Ruin', 'Subject1', 63, 1, '2022-01-02'),
(3, 'Arnold', 'Subject1', 95, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject1', 61, 1, '2022-01-02'),
(5, 'John Mike', 'Subject1', 91, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject2', 71, 1, '2022-01-02'),
(3, 'Arnold', 'Subject2', 32, 1, '2022-01-02'),
(5, 'John Mike', 'Subject2', 61, 2, '2022-11-02'),
(1, 'John Deo', 'Subject2', 60, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject2', 84, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject3', 29, 3, '2022-01-03'),
(5, 'John Mike', 'Subject3', 98, 2, '2022-11-02');
```

---
---

### 1. Get the list of students who scored above the average marks in each subject.

#### Expected Output


studentid |	studentname |
--|--|
2 |	Max Ruin |
3 |	 Arnold |
4 |	Krish Star |
5 |	John Mike |


#### Solution Query

```sql
WITH avg_cte AS (
    SELECT   subject, AVG(marks) as avg_marks
    FROM     students
    GROUP BY 1
)
SELECT   studentid, studentname
FROM     avg_cte ac JOIN students s USING(subject)
WHERE    marks > avg_marks
ORDER BY 1
```

---


### 2. Get the percentage of students who score more than 90 in any subject amongst the total students. 

#### Expected Output

percentage |
--|
40.0000000000000000 |


#### Solution Query

```sql
SELECT COUNT(DISTINCT CASE WHEN marks > 90 THEN studentid ELSE null END)*100.0 / COUNT(DISTINCT studentid) AS percentage
FROM   students
```

---

### 3. Get the second-highest and the second-lowest marks for each subject.

#### Expected Output

subject |	second_highest_marks |	second_lowest_marks |
--|--|--|
Subject1 |	91 |	63 |
Subject2 |	71 |	60 |
Subject3 |	29 |	98 |

#### Solution Query

```sql
WITH CTE AS (
    SELECT *, 
           RANK() OVER(PARTITION BY subject ORDER BY marks desc) as highest_rank,
           RANK() OVER(PARTITION BY subject ORDER BY marks) as lowest_rank
    FROM   students
)
SELECT   subject, 
         SUM(CASE WHEN highest_rank=2 THEN marks ELSE NULL END) as second_highest_marks,
         SUM(CASE WHEN lowest_rank=2 THEN marks ELSE NULL END) as second_lowest_marks
FROM     CTE
GROUP BY 1
```

---

### 4. For each student and test, identify if their marks increased or decreased from the previous test.

#### Expected Output

| studentid | marks | prev_marks | status    |
|-----------|-------|------------|-----------|
| 1         | 60    | null       | null      |
| 2         | 63    | null       | null      |
| 2         | 84    | 63         | increased |
| 2         | 29    | 84         | decreased |
| 3         | 95    | null       | null      |
| 3         | 32    | 95         | decreased |
| 4         | 61    | null       | null      |
| 4         | 71    | 61         | increased |
| 5         | 91    | null       | null      |
| 5         | 61    | 91         | decreased |
| 5         | 98    | 61         | increased |


#### Solution Query

```sql
WITH CTE AS (
    SELECT studentid,
           marks,
           LAG(marks) OVER(PARTITION BY studentid ORDER BY testdate, subject) AS prev_marks
    FROM   students
)
SELECT *, 
       CASE WHEN marks > prev_marks THEN 'inc'
            WHEN marks < prev_marks THEN 'dec'
            ELSE NULL 
       END AS statys
FROM CTE
```

---
