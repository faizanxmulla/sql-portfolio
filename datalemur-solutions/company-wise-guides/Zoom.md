## 11 Zoom SQL Interview Questions

### 1. Identify Power Users in Zoom

In a company like Zoom, we can define a power user as someone who hosts meetings very frequently, with a large number of participants and long durations. Power users are also likely to use the premium features of Zoom.

Assuming we have tables that capture users (users), meetings (meetings) and premium feature usage (premium_features), **write an SQL query to identify the power users**. 

A power user could be defined as someone who has hosted more than 10 meetings in the last month, with an average of more than 5 participants per meeting and a total of more than 20 premium features used in the last month.

`users` **Example Input:**

| user_id | name  |
|---------|-------|
| 1       | Alice |
| 2       | Bob   |
| 3       | Carlos|

`meetings` **Example Input:**

| meeting_id | host_user_id | participants | start_time          | end_time            |
|------------|---------------|--------------|----------------------|----------------------| 
| 101        | 1             | 10           | 2022-07-01 09:00:00 | 2022-07-01 10:00:00 |
| 102        | 1             | 7            | 2022-07-05 14:00:00 | 2022-07-05 15:30:00 |
| 103        | 2             | 4            | 2022-07-06 10:00:00 | 2022-07-06 11:00:00 |

`premium_features` **Example Input:**

| feature_id | user_id | usage_time          |
|------------|---------|----------------------| 
| 201        | 1       | 2022-07-01 09:30:00 |
| 202        | 1       | 2022-07-05 14:45:00 |
| 203        | 2       | 2022-07-06 10:30:00 |

**Answer:**

```sql
SELECT   u.name, 
         COUNT(m.meeting_id) as meetings_hosted, 
         AVG(m.participants) as avg_participants, 
         COUNT(p.feature_id) as premium_features_used
FROM     users u JOIN meetings m ON u.user_id = m.host_user_id
                 JOIN premium_features p ON u.user_id = p.user_id
WHERE    m.start_time >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month') AND 
         p.usage_time >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
GROUP BY 1
HAVING   COUNT(m.meeting_id) > 10 AND 
         AVG(m.participants) > 5 AND 
         COUNT(p.feature_id) > 20;
```

---

### 2. Calculate the Monthly Average Ratings For Each Product

As a data analyst at Zoom, you are asked to monitor the changes in user sentiment for each product by tracking monthly average ratings. Sort your final result by month in ascending order and product_id in ascending order within each month.

For instance, if a product received a rating of 4 stars on June 1st and a rating of 3 stars on June 30th, the average rating for that product in June would be (4+3) / 2 = 3.5.

`zoom_user_reviews` **Example Input:**

| review_id | user_id | submit_date         | product_id | stars |
|-----------|---------|----------------------|------------|-------|
| 201       | 11      | 02/01/2022 00:00:00 | 101        | 5     |
| 202       | 12      | 02/10/2022 00:00:00 | 102        | 3     |
| 203       | 13      | 03/01/2022 00:00:00 | 101        | 4     |
| 204       | 11      | 04/01/2022 00:00:00 | 101        | 2     |
| 205       | 14      | 05/01/2022 00:00:00 | 102        | 4     |

**Example Output:**

| month | product_id | avg_stars |
|-------|------------|-----------|
| 2     | 101        | 5.00      |
| 2     | 102        | 3.00      |
| 3     | 101        | 4.00      |
| 4     | 101        | 2.00      |
| 5     | 102        | 4.00      |

**Answer:**

Assuming that the table name is zoom_user_reviews, you can use the following SQL to get the average monthly ratings

```sql
SELECT   EXTRACT(MONTH FROM submit_date) as month, 
         product_id, 
         AVG(stars) as avg_stars
FROM     zoom_user_reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 3. What does the FOREIGN KEY constraint do?

A FOREIGN KEY is like a secret code that unlocks the door to another table. It's a field in one table that points to the PRIMARY KEY (the master key) in another table. This helps keep the data in your database organized and tidy, because it won't let you add new rows to the FOREIGN KEY table unless they have the correct secret code (a corresponding entry in the PRIMARY KEY table).

It's also like a special bond between the two tables - if you try to delete the PRIMARY KEY data, the FOREIGN KEY will be like "Whoa, hold on! I still need that information!" and prevent the deletion from happening.

---

### 4. Zoom Meeting Data Analysis

Zoom is a popular platform for conducting online meetings, webinars and providing collaborative workspace. As a data scientist in Zoom, you have been tasked with designing a database schema that captures details about users, meetings and the interaction between them.


`users` **Example Input:**

| user_id | account_type | signup_date | location       |
|---------|--------------|-------------|-----------------|
| 123     | Individual   | 12/18/2020  | Los Angeles, CA|
| 256     | Business     | 06/08/2020  | New York, NY   |
| 789     | Enterprise   | 01/25/2021  | San Francisco, CA|
| 973     | Individual   | 07/20/2021  | Chicago, IL    |
| 567     | Business     | 11/22/2020  | Houston, TX    |


`meetings` **Example Input:**

| meeting_id | host_user_id | start_time           | end_time             | meeting_type | participants_count |
|------------|--------------|---------------------|---------------------|--------------|--------------------|
| 70012     | 123           | 08/10/2022 09:00:00  | 08/10/2022 10:30:00  | Scheduled    | 15                 |
| 98052     | 789           | 08/10/2022 13:00:00  | 08/10/2022 14:00:00  | Recurring    | 100                |
| 64565     | 256           | 08/11/2022 15:00:00  | 08/11/2022 15:45:00  | Instant      | 7                  |
| 24680     | 973           | 08/11/2022 11:30:00  | 08/11/2022 12:30:00  | Scheduled    | 20                 |
| 56789     | 567           | 08/12/2022 09:30:00  | 08/12/2022 10:00:00  | Instant      | 10                 |

A common analysis might be to **determine the average number of meeting participants for each account type and meeting type to better understand how different account types use Zoom meetings.**

**Answer:**


```sql
SELECT   u.account_type, 
         m.meeting_type, 
         AVG(m.participants_count) as avg_participants
FROM     users u JOIN meetings m ON u.user_id = m.host_user_id
GROUP BY 1, 2
ORDER BY 1, 2
```

---


### 5. What does the SQL command INTERSECT do?

When using `INTERSECT`, only rows that are identical in both sets will be returned.

For a concrete example, say you were a Data Analyst supporting the Sales Analytics team at Zoom, and data on potential sales leads lived in both Salesforce and Hubspot CRMs. To write a query to analyze leads created before 2023 started, that show up in BOTH CRMs, you would use the `INTERSECT` command:

```sql
SELECT email, job_title, company_id
FROM   zoom_sfdc_leads
WHERE  created_at < '2023-01-01';

INTERSECT

SELECT email, job_title, company_id
FROM   zoom_hubspot_leads
WHERE  created_at < '2023-01-01'
```

---


### 6. Filtering Zoom Users based on Meeting Attendance
As an analyst at Zoom, you are given a task to filter out customers who attended more than 5 meetings in the last week and spent more than 60 minutes in total, and the meetings were not on a weekend. Here, a 'meeting' refers to a video conferencing session and the 'duration' refers to the total length of the meeting in minutes.

**Write a SQL query that filters these users from the meetings and attendance tables.**

`meetings` **Sample Input**

| meeting_id | date       | duration |
|------------|------------|----------|
| 102        | 2022-09-01 | 30       |
| 106        | 2022-09-02 | 60       |
| 110        | 2022-09-03 | 45       |
| 115        | 2022-09-04 | 90       |
| 120        | 2022-09-05 | 50       |

`attendance` **Sample Input**

| user_id | meeting_id |
|---------|------------|
| 7865    | 102        |
| 7865    | 106        |
| 9032    | 110        |
| 7865    | 110        |
| 7865    | 115        |
| 9032    | 115        |
| 7865    | 120        |
| 9032    | 120        |

**Answer:**

```sql
SELECT   a.user_id
FROM     attendance a JOIN meetings m USING(meeting_id)
WHERE    m.date >= current_date - INTERVAL '1 week' AND EXTRACT('ISODOW' FROM m.date) < 6
GROUP BY 1
HAVING   COUNT(m.meeting_id) > 5 AND SUM(m.duration) > 60
```


---

### 7. What does it mean to use a UNIQUE constraint in a database?

A `UNIQUE` constraint ensures that all values in a column are different. It is often used in conjunction with other constraints, such as `NOT NULL`, to ensure that the data meets certain conditions.

For example, if you had Zoom sales leads data stored in a database, here's some constraints you'd use:

```sql
CREATE TABLE zoom_leads (
    lead_id INTEGER PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255) NOT NULL UNIQUE
);
```

In this example, the `UNIQUE` constraint is applied to the "email" and "phone" fields to ensure that each Zoom lead has a unique email address and phone number. This helps to ensure the integrity of the data in the database and prevents errors that could occur if two leads had the same email address or phone number.


---

### 8. Calculate the Average Duration of Zoom Meetings

You are working as a data scientist at Zoom. The company wants to understand more about how long users are spending in meetings to drive business decisions. Can you write a SQL query to find the average duration of meetings hosted on Zoom platform in hours, grouped by month and year?

Note that duration is calculated as end_time - start_time and the result should be in hours.

`meetings` **Example Input:**

| meeting_id | user_id | start_time           | end_time             |
|------------|---------|----------------------|----------------------| 
| 101        | 500     | 2022-04-02 10:00:00  | 2022-04-02 12:00:00  |
| 102        | 501     | 2022-04-15 09:00:00  | 2022-04-15 10:05:00  |
| 103        | 502     | 2022-05-01 14:00:00  | 2022-05-01 15:00:00  |
| 104        | 503     | 2022-05-22 16:00:00  | 2022-05-22 18:00:00  |
| 105        | 504     | 2022-05-30 08:00:00  | 2022-05-30 08:50:00  |

**Example Output:**

| year | month | avg_duration_hr |
|------|-------|-----------------|
| 2022 | 04    | 1.52            |
| 2022 | 05    | 1.33            |

**Answer:**


```sql
SELECT   EXTRACT(YEAR FROM start_time) AS year,
         EXTRACT(MONTH FROM start_time) AS month,
         AVG(EXTRACT(EPOCH FROM (end_time - start_time)) / 3600) AS avg_duration_hr
FROM     Meetings
GROUP BY 1, 2
ORDER BY 1, 2
```

--- 

### 9. Get Average Meeting Duration per User

Given a table named meetings of Zoom's records, where each row represents an online meeting. Each meeting has an ID, the ID of the user who initiated the meeting, and the start and end times. 

Can you query the average duration (in minutes) of meetings initiated by each user?

`meetings` **Example Input:**

meeting_id |	user_id |	start_time |	end_time |
--|--|--|--|
1 |	101 |	2022-08-10 10:30:00 |	2022-08-10 10:50:00 |
2 |	102 |	2022-08-10 11:00:00 |	2022-08-10 11:45:00 |
3 |	101 |	2022-08-10 14:00:00 |	2022-08-10 14:30:00 |
4 |	102 |	2022-08-10 15:00:00 |	2022-08-10 16:30:00 |
5 |	103 |	2022-08-10 16:00:00 |	2022-08-10 16:15:00 |


**Example Output:**

user_id | avg_duration |
--|--|
101 |	25.00 |
102 |	67.50 |
103 |	15.00 |


Answer:

```SQL
SELECT   user_id, 
         AVG(EXTRACT(EPOCH FROM (end_time - start_time)) / 60) as avg_duration 
FROM     meetings
GROUP BY 1
```
---

### 10. What's a correlated sub-query? How does it differ from a non-correlated sub-query?

While a correlated subquery relies on columns in the main query's FROM clause and cannot function independently, a non-correlated subquery operates as a standalone query and its results are integrated into the main query.

An example correlated sub-query:

```sql
SELECT name, salary
FROM   zoom_employees e1
WHERE  salary > (
         SELECT AVG(salary) 
         FROM   zoom_e2 
         WHERE  e1.department = e2.department
     );
```

This correlated subquery retrieves the names and salaries of Zoom employees who make more than the average salary for their department. 

The subquery references the department column in the main query's FROM clause (e1.department) and uses it to filter the rows of the subquery's FROM clause (e2.department).

An example non-correlated sub-query:

```sql
SELECT name, salary
FROM   zoom_employees
WHERE  salary > (
        SELECT AVG(salary) 
        FROM   zoom_employees 
        WHERE  department = 'Data Science'
    );
```

This non-correlated subquery retrieves the names and salaries of Zoom employees who make more than the average salary for the Data Science department (which honestly should be very few people since Data Scientists are awesome and deserve to be paid well).

The subquery is considered independent of the main query can stand alone. Its output (the average salary for the Data Science department) is then used in the main query to filter the rows of the Zoom employees table.

---

### 11. Analyzing Zoom Customer Meeting Durations and Participations

Please write a SQL query that will tell us the average meeting duration per customer and the total number of participants in their meetings. 

For this question, assume that we have two tables - `customers` and `meetings`. It is also assumed that a meeting could have multiple participants but each has a unique meeting_id.

Here's some sample data for our customers and meetings tables:

`customers` **Example Input:**

customer_id |	first_name |	last_name |	signup_date |
--|--|--|--|
101 |	John |	Doe |	2018-05-01 |
102 |	Jane |	Smith |	2019-03-17 |
103 |	Alice |	Johnson |	2020-12-04 |


`meetings` **Example Input:**

meeting_id |	customer_id |	duration_mins |	participants |
--|--|--|--|
201 |	101 |	30 |	6 |
202 |	101 |	60 |	10 |
203 |	102 |	45 |	8 |
204 |	103 |	30 |	5 |
205 |	103 |	60 |	7 |


**Example Output:**

customer_id |	avg_duration_mins |	total_participants |
--|--|--|
101 |	45.00 |	16 |
102 |	45.00 |	8 |
103 |	45.00 |	12 |


**Answer:**

```sql
SELECT   m.customer_id, 
         AVG(m.duration_mins) AS avg_duration_mins, 
         SUM(m.participants) AS total_participants
FROM     meetings m JOIN customers c USING(c.customer_id)
GROUP BY 1 
ORDER BY 1
```

---