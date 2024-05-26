## 9 HubSpot SQL Interview Questions

### 1. Average Rating by Month per Product
For this question, we have a dataset of product reviews at HubSpot with each row in the dataset representing a single review. Each review has a unique `review_id`, the id of the `user_id` who gave the review, the `submit_date` when the review was submitted, the `product_id`, and the number of `stars` the product was given.

As a data analyst at HubSpot, one of your tasks is to understand the performance of each product over time. 

Your task is to write a SQL query that calculates the average rating (star) per month for each product.

`reviews` Example Input:

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|-------------|------------|--------|
| 6171      | 123     | 2022-08-06  | 50001      | 4      |
| 7802      | 265     | 2022-10-06  | 69852      | 4      |
| 5293      | 362     | 2022-18-06  | 50001      | 3      |
| 6352      | 192     | 2022-26-07  | 69852      | 3      |
| 4517      | 981     | 2022-05-07  | 69852      | 2      |

`reviews` Expected Output:

| month | product_id | avg_stars |
|-------|------------|-----------|
| 6     | 50001      | 3.50      |
| 6     | 69852      | 4.00      |
| 7     | 69852      | 2.50      |

Answer:
```sql
SELECT   EXTRACT(MONTH FROM submit_date) AS month, 
         product_id, 
         AVG(stars) AS avg_stars
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 2. Customer Activity Filtering

HubSpot is running a marketing campaign and they would like to target customers who have not made a purchase in the last six months but have been active in the last 30 days. Active is defined as logging into their account. 

Please write a SQL query to generate a list of customers' ID and their last login date who meet these criteria from the "customers", "log_activity", and "purchases" tables.

`customers` Sample Input:
| customer_id | name         | email               |
|-------------|--------------|-------------------|
| 105         | John Doe     | jdoe@example.com   |
| 210         | Jane Smith   | jsmith@example.com |
| 315         | Mark Johnson | mjohnson@example.com|

`log_activity` Sample Input:
| customer_id | login_date |
|-------------|------------|
| 105         | 2022-07-05 |
| 210         | 2022-09-02 |
| 315         | 2022-09-02 |

`purchases` Sample Input:
| customer_id | purchase_date |
|-------------|---------------|
| 105         | 2022-02-20    |
| 210         | 2021-12-23    |
| 315         | 2022-04-01    |

Answer:
```sql
-- no purchase for last 6 months
-- but active i.e. logged in last 30 days


-- customer_id, last_login_date

SELECT   customer_id, MAX(l.login_date) as last_login_date
FROM     customers c JOIN log_activity la USING(customer_id)
                     LEFT JOIN purchases p USING(customer_id)
WHERE    l.login_date > CURRENT_DATE - interval '30 days' AND (p.purchase_date < CURRENT_DATE - interval '6 months' OR p.purchase_date IS NULL)
GROUP BY 1
```

---

### 3. What does EXCEPT / MINUS SQL commands do?

The `MINUS`/`EXCEPT` operator is used to remove to return all rows from the first `SELECT` statement that are not returned by the second `SELECT` statement.

Note that `EXCEPT` is available in PostgreSQL and SQL Server, while `MINUS` is available in MySQL and Oracle (but don't worry about knowing which DBMS supports which exact commands since HubSpot interviewers aren't trying to trip you up on memorizing SQL syntax).

For a tangible example of `EXCEPT` in PostgreSQL, suppose you were doing an HR Analytics project for HubSpot, and had access to HubSpot's contractors and employees data. Assume that some employees were previously contractors, and vice versa, and thus would show up in both tables.

You could use `EXCEPT` operator to find all contractors who never were a employee using this query:

```sql
SELECT first_name, last_name
FROM hubspot_contractors

EXCEPT

SELECT first_name, last_name
FROM hubspot_employees
```

---

### 4. Find the Average Length of Each Marketing Campaign

As a data analyst at HubSpot, you are given a task to analyze the marketing campaigns data. Your manager wants to understand the average length of each marketing campaign in terms of days. Write a SQL query to find the average length per campaign based on the provided data.

Here's how you could format your data:

`campaigns` Example Input:

| campaign_id | start_date | end_date |
|-------------|------------|----------|
| 101         | 2022-01-01 | 2022-01-15 |
| 102         | 2022-01-20 | 2022-02-10 |
| 103         | 2022-02-01 | 2022-02-28 |
| 104         | 2022-03-01 | 2022-03-15 |
| 105         | 2022-03-20 | 2022-04-10 |

Example Output:
| campaign_id | avg_length_in_days |
|-------------|-------------------|
| 101         | 14.00             |
| 102         | 21.00             |
| 103         | 27.00             |
| 104         | 14.00             |
| 105         | 21.00             |

Answer:

```sql
SELECT   campaign_id, 
         AVG(end_date - start_date) AS avg_length_in_days
FROM     campaigns
GROUP BY 1
```

---


### 5. How do relational and non-relational databases differ?


- **Data model**: Relational databases use a data model consisting of tables and rows, while NoSQL databases use a variety of data models, including document, key-value, columnar, and graph storage formats.

- **Data integrity**: Relational databases use structured query language (SQL) and enforce strict data integrity rules through the use of foreign keys and transactions. NoSQL databases may not use SQL and may have more relaxed data integrity rules.

- **Structure**: Relational databases store data in a fixed, structured format, while NoSQL databases allow for more flexibility in terms of data structure.

- **ACID compliance**: Relational databases are typically into shrooms and are ACID-compliant (atomic, consistent, isolated, and durable), while NoSQL databases may not be fully ACID-compliant.

---

### 6. Analyze Click-Through Rates for HubSpot's Digital Ads

HubSpot, a leading marketing, sales, and service software company, is keen on analyzing the click-through rates of its digital ads. They have the `ads` table that stores data about each ad, and the `clicks` table that holds information when an ad is clicked.

Given the `ads` and `clicks` tables, can you write a query to find the click-through rate for each ad? Assume that the click-through rate is defined as the total number of unique clicks a particular ad gets divided by the total number of times it's shown, represented as a percentage.

`ads` Example Input:

| ad_id | ad_name            | times_shown |
|-------|-------------------|--------------|
| 101   | 'Summer Sale'     | 12500        |
| 102   | 'Winter Clearance'| 15000        |
| 103   | 'Spring Promo'    | 15000        |
| 104   | 'Fall Special'    | 13500        |

`clicks` Example Input:

| click_id | ad_id |
|----------|-------|
| 5001     | 101   |
| 5002     | 101   |
| 5003     | 102   |
| 5004     | 103   |
| 5005     | 104   |
| 5006     | 104   |

Answer:
```sql
SELECT   a.ad_id, 
         COUNT(DISTINCT c.click_id) AS unique_clicks,
         CAST(COUNT(DISTINCT c.click_id) AS FLOAT) / a.times_shown * 100 AS ctr
FROM     ads a LEFT JOIN clicks c USING(ad_id)
GROUP BY 1, a.times_shown
```

---

### 7. How would you improve the performance of a slow SQL query?

There's several steps you can take to troubleshoot a slow SQL query.

First things first, figure out why the query is slow! You can use `ANALYZE` and `EXPLAIN` commands in PostgreSQL to identify any performance bottlenecks. After that, you can start changing your query, depending on what the source of the query performance issue is.

Generally, indexes can help speed up queries. Also de-normalizing your tables might help, to remove slow joins.

---

### 8. Calculating Email Performance Metrics

HubSpot has a table `email_campaign_stats` which captures information about how a particular email campaign performed.

The table has the following schema:

`email_campaign_stats` Example Input:

| email_id | sent_at   | recipients | open_rate | click_through_rate |
|----------|-----------|------------|-----------|-------------------|
| 7457     | 2022-08-01| 12000      | 0.205     | 0.035             |
| 8934     | 2022-08-02| 9900       | 0.198     | 0.060             |
| 5629     | 2022-08-03| 11500      | 0.185     | 0.042             |
| 9275     | 2022-08-04| 13500      | 0.211     | 0.048             |
| 4631     | 2022-08-05| 11200      | 0.195     | 0.050             |

The `open_rate` and `click_through_rate` are represented as a percentage of the total `recipients`. Your boss wants to know the absolute number of people who opened the email and those who clicked a link in the email each day, rounded to the nearest integer. 

How would you generate this report using SQL?

Answer:

```sql
SELECT email_id, 
       sent_at, 
       recipients,
       ROUND(recipients * open_rate) AS opened_emails,
       ROUND(recipients * click_through_rate) AS clicked_emails
FROM   email_campaign_stats;
```

---

### 9. Analyzing User Engagement

HubSpot is well known for its CRM platform where there are a variety of user actions that can be taken such as sending an email, logging in, or updating a contact field. Your task is to find out the daily active users over the past week.

Let's assume that we have an `event_activity_log` table as follows:

`activity_log` Example Input:

| activity_id | user_id | activity_type | timestamp |
|-------------|---------|---------------|-----------|
| 1234        | 567     | login         | 2022-09-01 12:30:00 |
| 2314        | 890     | update_contact| 2022-09-01 13:20:00 |
| 2341        | 567     | send_email    | 2022-09-02 10:10:00 |
| 1492        | 998     | login         | 2022-09-03 11:45:00 |
| 8992        | 776     | update_contact| 2022-09-03 18:20:00 |

We want to identify daily active users, i.e., users that performed any activity in the system. Therefore, we count a user as "active" on a particular day if there is any row in the table with their `user_id` and that timestamp.

Example Output:

| date       | active_users |
|------------|--------------|
| 2022-09-01 | 2            |
| 2022-09-02 | 1            |
| 2022-09-03 | 2            |

Answer:

```sql
SELECT   CAST(timestamp AS DATE) AS date, 
         COUNT(DISTINCT user_id) as active_users
FROM     activity_log
WHERE    timestamp >= NOW() - INTERVAL '1 week'
GROUP BY 1
ORDER BY 1
```


---