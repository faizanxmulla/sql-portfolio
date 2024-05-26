## 8 Coursera SQL Interview Questions

### 1. Average Course Ratings Over Time

Imagine we have a dataset of reviews for different courses on Coursera. We'd like to query this dataset in order to find the average score per course per month. 

Will you be able to create an SQL query that would yield the average (mean) review score (stars), per course (product_id), per month, from this dataset?

We have the following example `reviews` table:

`reviews` **Example Input:**

| review_id | user_id | submit_date         | product_id | stars |
|-----------|---------|----------------------|------------|-------|
| 1         | 123     | 2022-06-01 00:00:00 | 101        | 4     |
| 2         | 234     | 2022-06-20 00:00:00 | 102        | 3     |
| 3         | 345     | 2022-06-20 00:00:00 | 101        | 5     |
| 4         | 456     | 2022-07-10 00:00:00 | 102        | 2     |
| 5         | 567     | 2022-07-25 00:00:00 | 101        | 3     |
| 6         | 678     | 2022-07-28 00:00:00 | 102        | 5     |

**Answer:**

```sql
SELECT   TO_CHAR(submit_date, 'YYYY-MM') as month,
         product_id,
         AVG(stars) as avg_stars
FROM     reviews 
GROUP BY 1, 2
ORDER BY 1, 2
```



---

### 2. Find the number of courses taken by users from different countries

As a Data analyst at Coursera, you are required to analyse the user activity of their platform. 

For each country, your task is to find out how many courses are taken by the users in the year 2022 until the end of September.

Use the following two tables for this task:

`users`

| user_id | name    | country |
|---------|---------|---------|
| 685     | Andrew  | USA     |
| 347     | Maria   | Canada  |
| 932     | Liam    | USA     |
| 487     | Rutvik  | India   |
| 291     | Emma    | Canada  |

`courses`

| course_id | user_id | course_name        | start_date |
|-----------|---------|---------------------|------------|
| 731       | 685     | Data Science        | 04/08/2022 |
| 894       | 347     | Machine Learning    | 08/01/2022 |
| 662       | 932     | Computer Science    | 06/10/2022 |
| 248       | 487     | Software Engineering| 03/19/2022 |
| 923       | 291     | Artificial Intelligence | 05/25/2022 |

**Answer:**

```sql
SELECT   u.country, COUNT(c.course_id) AS number_of_courses
FROM     users u JOIN courses c USING(user_id)
WHERE    DATE(c.start_date) BETWEEN '2022-01-01' AND '2022-09-31'
GROUP BY 1
```

---

### 3. In SQL, are NULL values same the same as zero or a blank space?

In SQL, zero's are numerical values which can be used in calculations and comparisons just like any other number. A blank space, also known as an empty string, is a character value and can be used in character manipulation functions and comparisons.

NULLs aren't the same as zero's or blank spaces. NULLs represent unkonwn, missing, or not applicable values. They are not included in calculations and comparisons involving NULL values always result in NULL.

---

### 4. Average Course Rating on Coursera

For Coursera, an online learning platform, the review system allows students to rate the courses they have taken. 

The question is: **What is the average rating for each course on Coursera?**

To answer this, we'll utilize the `AVG()` function in SQL, and consider two tables: `courses` and `reviews`.

`courses` **Sample Input:**

| course_id | course_name           | subject             |
|-----------|------------------------|----------------------|
| 101       | Python for Everybody  | Programming         |
| 102       | Data Science in R     | R-Language          |
| 103       | Machine Learning      | Artificial Intelligence|

`reviews` **Sample Input:**

| review_id | course_id | user_id | rating |
|-----------|-----------|---------|--------|
| 1         | 101       | 200     | 5      |
| 2         | 101       | 201     | 4      |
| 3         | 102       | 202     | 3      |
| 4         | 102       | 203     | 2      |
| 5         | 103       | 204     | 3      |
| 6         | 103       | 205     | 4      |

**Answer:**

```sql
SELECT   course_name, AVG(rating) as avg_rating 
FROM     courses c JOIN reviews r USING(course_id)
GROUP BY 1
```


---

### 5. What's a correlated sub-query? How does it differ from a non-correlated sub-query?

While a correlated subquery relies on columns in the main query's `FROM` clause and cannot function independently, a non-correlated subquery operates as a standalone query and its results are integrated into the main query.

An example correlated sub-query:

```sql
SELECT name, salary
FROM   coursera_employees e1
WHERE  salary > (
            SELECT AVG(salary) 
            FROM   coursera_e2 
            WHERE  e1.department = e2.department
        );
```

This correlated subquery retrieves the names and salaries of Coursera employees who make more than the average salary for their department. The subquery references the `department` column in the main query's `FROM` clause (`e1.department`) and uses it to filter the rows of the subquery's `FROM` clause (`e2.department`).

An example non-correlated sub-query:

```sql
SELECT name, salary
FROM   coursera_employees
WHERE  salary > (
            SELECT AVG(salary) 
            FROM   coursera_employees 
            WHERE  department = 'Data Science'
        );
```

This non-correlated subquery retrieves the names and salaries of Coursera employees who make more than the average salary for the Data Science department (which honestly should be very few people since Data Scientists are awesome and deserve to be paid well).The subquery is considered independent of the main query can stand alone. Its output (Here's the rest of the explanation:

The subquery is considered independent of the main query and can stand alone. Its output (the average salary for the Data Science department) is then used in the main query to filter the rows of the `coursera_employees` table.

---

### 6. Calculate Average Course Rating

You've been given two tables: `reviews` and `courses`. The `reviews` table contains all reviews submitted, and the `courses` table contains all courses provided by Coursera.

The `reviews` table has columns for `review_id` (the unique identifier of each review), `course_id` (the unique identifier of the course), `user_id` (the unique identifier of the user), `submit_date` (the date the review was submitted), and `stars` (the rating given to the course; could be 1, 2, 3, 4, or 5).

The `courses` table has columns for `course_id` and `course_name`.

For each course, **find the average rating for the month of August 2022.**

`reviews` **Example Input:**

| review_id | user_id | submit_date | course_id | stars |
|-----------|---------|--------------|-----------|-------|
| 1211      | 768     | 08/06/2022   | 1001      | 4     |
| 2917      | 256     | 08/11/2022   | 2002      | 4     |
| 5012      | 963     | 08/18/2022   | 1001      | 3     |
| 3242      | 192     | 08/26/2022   | 3003      | 5     |
| 1417      | 191     | 08/05/2022   | 2002      | 2     |

`courses` **Example Input:**

| course_id | course_name         |
|-----------|----------------------|
| 1001      | Physics I            |
| 2002      | Math 101             |
| 3003      | Intro to Programming |

**Example Output:**

| month | course_name         | avg_rating |
|-------|----------------------|------------|
| 8     | Physics I            | 3.50       |
| 8     | Math 101             | 3.00       |
| 8     | Intro to Programming | 5.00       |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) AS month,
         course_name,
         AVG(stars) as avg_rating
FROM     reviews AS r JOIN courses AS c USING(course_id)
WHERE    EXTRACT(MONTH FROM submit_date) = 8 AND 
         EXTRACT(YEAR FROM submit_date) = 2022 
GROUP BY 1, 2
```


---

### 7. When doing database schema design, what's an example of two entities that have a one-to-one relationship? What about one-to-many relationship?

In database schema design, a **one-to-one relationship** is when each entity is associated with only one instance of the other. For instance, a US citizen's relationship with their social-security number (SSN) is one-to-one because each citizen can only have one SSN, and each SSN belongs to one person.

A **one-to-many relationship**, on the other hand, is when one entity can be associated with multiple instances of the other entity. An example of this is the relationship between a person and their email addresses - one person can have multiple email addresses, but each email address only belongs to one person.

---  

### 8. Find the Average Rating for Every Course

Query the Coursera database to obtain a monthly breakdown of the average rating for every course, by joining the `reviews` table with the `courses` table. The results should be present for each month and each course.

`reviews`

| review_id | user_id | submit_date | course_id | stars |
|-----------|---------|--------------|-----------|-------|
| 1001      | 1       | 01/03/2022   | 101       | 5     |
| 1002      | 2       | 01/10/2022   | 101       | 4     |
| 1003      | 3       | 02/15/2022   | 102       | 5     |
| 1004      | 4       | 02/20/2022   | 102       | 4     |
| 1005      | 5       | 03/03/2022   | 101       | 5     |

`courses`

| course_id | course_name    |
|-----------|-----------------|
| 101       | SQL for Beginners|
| 102       | Advanced SQL    |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) as mth, 
         course_name,
         AVG(stars) as avg_stars
FROM     reviews r LEFT JOIN courses c USING(course_id)
GROUP BY 1, 2
ORDER BY 1, 2
```

---