## 10 GitLab SQL Interview Questions

### 1. Calculate the Monthly Active Users

Assume GitLab keeps track of its users' activities in a table user_activities. Each time a user performs an important activity (e.g. commit code, create merge request, or push code), a new row is added to the table. 

**Write a SQL query to calculate the number of monthly active users** (MAU), where an active user in a given month is defined as a user who has performed at least one activity in that month.

Here is some sample data for user_activities:

`user_activities` **Example Input:**

| activity_id | user_id | activity_date            | activity_type |
|-------------|---------|--------------------------|----------------|
| 101         | 123     | 2022-08-06 00:00:00     | commit         |
| 102         | 265     | 2022-10-06 00:00:00     | merge_request  |
| 103         | 362     | 2022-11-18 00:00:00     | commit         |
| 104         | 192     | 2023-02-26 00:00:00     | push           |
| 105         | 981     | 2023-05-05 00:00:00     | merge_request  |

The output should have one row for each month (with the month formatted as yyyy-mm), and include the total count of active users for that month.

**Example Output:**

| month   | active_users |
|---------|--------------|
| 2022-08 | 1            |
| 2022-10 | 1            |
| 2022-11 | 1            |
| 2023-02 | 1            |
| 2023-05 | 1            |

**Answer:**

```sql
SELECT   TO_CHAR(activity_date, 'YYYY-MM') as month, 
         COUNT(DISTINCT user_id) as active_users
FROM     user_activities
GROUP BY 1
ORDER BY 1
```



### 2. Filtering GitLab User Activities

As an analyst at GitLab, one of your task is to monitor user activity on the platform. 

Create an SQL query that **filters GitLab users who had logged in within the last 30 days but have not used any GitLab features within the same period.**

Please consider the following markdown-formatted tables for this task:

`users` **Example Input:**

| user_id | username | login_date |
|---------|----------|------------|
| 6171    | user123  | 08/28/2022 |
| 7802    | user265  | 09/08/2022 |
| 5293    | user362  | 07/20/2022 |
| 6352    | user192  | 08/30/2022 |
| 4517    | user981  | 07/12/2022 |

`user_activities` **Example Input:**

| activity_id | user_id | feature_used       | date       |
|-------------|---------|---------------------|------------|
| 8521        | 6171    | Repository Creation | 08/15/2022 |
| 3102        | 7802    | Merge Requests      | 09/08/2022 |
| 4209        | 5293    | CI/CD Pipeline      | 05/18/2022 |
| 7305        | 6352    | Issue Tracker       | 07/26/2022 |
| 9701        | 4517    | Repository Creation | 07/05/2022 |

**Answer:**

```sql
SELECT u.user_id, username
FROM   users u LEFT JOIN user_activities ua USING(user_id)
WHERE  login_date >= NOW() - INTERVAL '30 days' AND 
       (ua.date < NOW() - INTERVAL '30 days' OR 
       ua.date IS NULL)
```



---

### 3. What is denormalization?

Denormalization is the practice of altering a database schema in a way that breaks the normalization rules (1NF, 2NF, 3NF, etc.).

This is typically done to improve the performance of the database when it is being used for online analytics processing (OLAP), rather than online transaction processing (OLTP) use cases.

Denormalization can improve query performance by reducing the number of expensive joins required to retrieve data, but it comes with it's own drawbacks too. By adding redundant columns, you incur more data storage costs, and there's need for more complex update and delete operations in order to maintain data integrity across all the duplicated data. Thus, it's important to carefully consider the trade-offs involved before implementing denormalization.


---


### 4. Calculating Average Merge Request Time in GitLab

GitLab uses the concept of "merge requests" for proposing changes from one branch to another. 

In a typical setup, developers make changes in their local branches and then create a merge request to propose those changes into a shared branch (like 'master' or 'main').

Assuming we have a table merge_requests that records each merge request, including its id, the requester_id (the developer who proposed the change), the creation_date (the date and time when the merge request was created), the merge_date (the date and time when the merge request was accepted and merged), and the branch_id (the id of the branch into which the changes are proposed)

Write a SQL query to **find the average time (in hours) it takes for a merge request to be accepted for each branch**

`merge_requests` **Example Input:**

| id | requester_id | creation_date          | merge_date             | branch_id |
|----|--------------|------------------------|------------------------|-----------|
| 1  | 101          | 2022-06-01 10:00:00    | 2022-06-01 12:00:00    | 5001      |
| 2  | 102          | 2022-06-02 09:00:00    | 2022-06-02 11:30:00    | 5001      |
| 3  | 101          | 2022-07-01 14:00:00    | 2022-07-02 10:00:00    | 5002      |
| 4  | 103          | 2022-07-02 09:00:00    | 2022-07-03 09:30:00    | 5002      |
| 5  | 104          | 2022-07-03 11:00:00    | NULL                   | 5002      |

**Example Output:**

| branch_id | avg_merge_time_in_hours |
|-----------|-------------------------|
| 5001      | 2.25                    |
| 5002      | 20.25                   |

**Answer:**

```sql
SELECT   branch_id,
         AVG(EXTRACT(HOUR FROM merge_date - creation_date)) as avg_merge_time_in_hours
FROM     merge_requests
WHERE    merge_date IS NOT NULL
GROUP BY 1
```

---


### 5. What sets the 'BETWEEN' and 'IN' operators apart?

The `BETWEEN` operator is used to select rows that fall within a certain range of values, while the `IN` operator is used to select rows that match values in a specified list.

For example, suppose you are a data analyst at GitLab and have a table of advertising campaign data. To find campaigns with a spend between 1k and 5k, you could use `BETWEEN`:

```sql
SELECT * 
FROM   gitlab_ad_campaigns
WHERE  spend BETWEEN 1000 AND 5000;
```

To find advertising campaigns that were video and image based (as opposed to text or billboard ads), you could use the `IN` operator:

```sql
SELECT *
FROM   gitlab_ad_campaigns
WHERE  media_type IN ("video", "image");
```

---

### 6. Analyze Click-Through-Rate for GitLab

In GitLab, there are two important touchpoints users go through. The first is visiting the home page (page_views), and the second is clicking on a particular repository (repo_clicks).

The click-through rate (CTR) is calculated as the number of repository clicks divided by the number of page views. 

**Write an SQL query to determine the CTR for each day.**

`page_views` **Example Input:**

| view_id | user_id | view_date | page_id |
|---------|---------|-----------|---------|
| 12345   | 567     | 2022/06/08| 0101    |
| 12346   | 568     | 2022/06/08| 0101    |
| 12347   | 569     | 2022/06/09| 0101    |
| 12348   | 570     | 2022/06/09| 0101    |
| 12349   | 571     | 2022/06/10| 0101    |

`repo_clicks` **Example Input:**

| click_id | user_id | click_date | repo_id |
|----------|---------|------------|---------|
| 56789    | 567     | 2022/06/08 | 0202    |
| 56790    | 568     | 2022/06/08 | 0101    |
| 56791    | 569     | 2022/06/09 | 0101    |
| 56792    | 560     | 2022/06/10 | 0202    |
| 56793    | 561     | 2022/06/10 | 0101    |

**Answer:**

```sql
WITH daily_page_views AS (
    SELECT   view_date, COUNT(*) AS num_views
    FROM     page_views
    GROUP BY 1
),
daily_repo_clicks AS (
    SELECT   click_date, COUNT(*) AS num_clicks
    FROM     repo_clicks
    GROUP BY 1
)
SELECT dpv.view_date, 
       drc.num_clicks::FLOAT / NULLIF(dpv.num_views, 0) AS click_through_rate
FROM   daily_page_views dpv LEFT JOIN daily_repo_clicks drc ON dpv.view_date = drc.click_date;
```

---

### 7. How do cross joins and natural joins differ?  

Cross joins and natural joins are two types of JOIN operations in SQL that are used to combine data from multiple tables. 

A cross join creates a new table by combining each row from the first table with every row from the second table, and is also known as a cartesian join. 

On the other hand, a natural join combines rows from two or more tables based on their common columns, forming a new table. 

One key difference between these types of JOINs is that cross joins do not require common columns between the tables being joined, while natural joins do.

Here's an example of a cross join:

```sql
SELECT products.name AS product, colors.name AS color
FROM   products CROSS JOIN colors;
```

If you have 20 products and 10 colors, that's 200 rows right there!

Here's a natural join example using two tables, GitLab employees and GitLab managers:

```sql
SELECT *
FROM   gitlab_employees LEFT JOIN gitlab_managers
ON     gitlab_employees.id = gitlab_managers.id
WHERE  gitlab_managers.id IS NULL;
```

This natural join returns all rows from GitLab employees where there is no matching row in managers based on the id column.

---

### 8. Finding GitLab Users Based on Email Domain

GitLab is a popular online service that allows developers to collaborate on projects. Suppose GitLab has a users database, and you're given a task to find all users who are using a specific company email domain (for example, 'gitlab.com') for their account.

Please **filter the data from the users database table to return only those records that have an email address ending in '@gitlab.com'**. 

Additionally, we are interested in the 'username', 'email', 'confirmed_at', and 'last_sign_in_at' fields.

`users` **Example Input:**


| user_id | username | email                   | confirmed_at | last_sign_in_at |
|---------|----------|-------------------------|--------------|-----------------|
| 1001    | user1    | user1@company.com       | 2020-01-01   | 2021-12-30      |
| 1002    | user2    | user2@company.com       | 2020-02-02   | 2022-01-15      |
| 1003    | user3    | user3@gitlab.com        | 2020-03-03   | 2022-01-20      |
| 1004    | user4    | user4@gitlab.com        | 2020-04-04   | 2021-12-25      |
| 1005    | user5    | user5@anothercompany.com| 2020-05-05   | 2022-01-25      |

**Example Output:**

| username | email             | confirmed_at | last_sign_in_at |
|----------|-------------------|--------------|-----------------|
| user3    | user3@gitlab.com  | 2020-03-03   | 2022-01-20      |
| user4    | user4@gitlab.com  | 2020-04-04   | 2021-12-25      |

**Answer:**

```sql
SELECT username, email, confirmed_at, last_sign_in_at
FROM   users
WHERE  email LIKE '%@gitlab.com';
```



---

### 9. Determining the Project Engagement Level

As a data analyst at GitLab, one company data you might be interested in is the engagement level of different projects happening within the company. 

You are given two tables, users and commit_records. 

- The `users` table contains information about each user's name and user ID. 

- The `commit_records` table contains data about each project's commit history: the user ID of the contributor, the project ID they worked on, and the date they made the commit.

Your task is to **write an SQL query to find the total number of commits each user has made per project**, join that with the users' table, and order the result by the project ID in ascending order and then the total number of commits in descending order.

`users` **Example Input:**

| user_id | user_name |
|---------|-----------|
| 101      | Alice     |
| 102      | Bob       |
| 103      | Charlie   |
| 104      | David     |

`commit_records` **Example Input:**

| user_id | project_id | commit_date |
|---------|------------|-------------|
| 101     | 1001       | 2022-01-02  |
| 101     | 1001       | 2022-01-05  |
| 102     | 1001       | 2022-01-07  |
| 101     | 1002       | 2022-01-08  |
| 103     | 1002       | 2022-01-11  |
| 103     | 1002       | 2022-01-14  |
| 104     | 1003       | 2022-01-22  |

**Answer:**

```sql
SELECT   u.user_name, c.project_id, COUNT(*) AS total_commits
FROM     commit_records AS c JOIN users AS u USING(user_id)
GROUP BY 1, 2
ORDER BY 2, 3 DESC
```

---

### 10. What are database views used for?

Database views are created to provide customized, read-only versions of your data that you can query just like a regular table. So why even use one if they're just like a regular table?

Views are useful for creating a simplified version of your data for specific users, or for hiding sensitive data from certain users while still allowing them to access other data.

Some key benefits of using views include:

- **Simplicity:** Views can present a simplified version of your data by hiding complex joins or aggregations from the end user.

- **Security:** Views can restrict access to sensitive data by only exposing certain columns or rows.

- **Reusability:** Views provide a reusable query that can be accessed like a table.

- **Abstraction:** Views can abstract away the underlying table structure, making schema changes more transparent to applications.

Overall, views are a helpful tool for data analysts and other users who need customized access to subsets of data without compromising security or exposing complex table structures.

---