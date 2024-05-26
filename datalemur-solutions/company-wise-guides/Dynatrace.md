## 9 Dynatrace SQL Interview Questions

### 1. Analyzing System Performance Metrics

Dynatrace is a company that specializes in software intelligence, providing tools for managing and understanding complex IT ecosystems. As an interviewee, you have been presented with a dataset comprising of system performance metrics and you have been tasked with the job of analyzing this data to understand the behavior of various systems over time.

**Write a SQL query that will calculate the average, maximum and minimum CPU usage for each system, each day using the window function.**

**Example Input:**

`performance_metrics` Table:

| pm_id | system_id | sample_time           | cpu_usage |
|-------|-----------|------------------------|-----------|
| 101   | 1         | 06/08/2022 00:00:00   | 0.6       |
| 102   | 1         | 06/08/2022 01:00:00   | 0.7       |
| 103   | 1         | 06/09/2022 00:00:00   | 0.9       |
| 104   | 2         | 06/08/2022 00:00:00   | 0.4       |
| 105   | 2         | 06/09/2022 00:00:00   | 0.5       |
| 106   | 2         | 06/09/2022 01:00:00   | 0.6       |


**Example Output:**

system_id |	date |	avg_usage |	max_usage |	min_usage |
--|--|--|--|--|
1 |	06/08/2022 |	0.65 |	0.7 |	0.6 |
1 |	06/09/2022 |	0.9 |	0.9 |	0.9 |
2 |	06/08/2022 |	0.4 |	0.4 |	0.4 |
2 |	06/09/2022 |	0.55 |	0.6 |	0.5 |

**Solution:**

```sql
SELECT   system_id,
         DATE(sample_time) AS date,
         AVG(cpu_usage) OVER(PARTITION BY system_id, DATE(sample_time)) as avg_cpu_usage,
         MAX(cpu_usage) OVER(PARTITION BY system_id, DATE(sample_time)) as max_cpu_usage,
         MIN(cpu_usage) OVER(PARTITION BY system_id, DATE(sample_time)) as min_cpu_usage
FROM     performance_metrics
ORDER BY 1, 2
```

---

### 2. Find Active Customers with Annual Subscription

Dynatrace, a software intelligence company, maintains a database of their customers. They are interested in identifying customers with an active annual subscription for any of their software products.

You are provided with the following two tables:

**Example Input:**

`customers` Table:

| customer_id | first_name | last_name | email                  |
|-------------|------------|-----------|------------------------|
| 1           | John       | Doe       | johndoe@example.com     |
| 2           | Jane       | Smith     | janesmith@example.com   |
| 3           | Jim        | Brown     | jimbrown@example.com    |
| 4           | Julie      | Johnson   | juliejohnson@example.com|
| 5           | Jerry      | Davis     | jerrydavis@example.com  |

`subscriptions` Table:

| subscription_id | customer_id | product_name | start_date  | end_date    | subscription_type |
|-----------------|-------------|--------------|-------------|-------------|-------------------|
| 10              | 1           | Software A   | 2021-01-01  | 2022-12-31  | annual            |
| 11              | 2           | Software B   | 2022-01-01  | 2022-06-30  | half_yearly       |
| 12              | 3           | Software A   | 2023-01-01  | 2023-12-31  | annual            |
| 13              | 2           | Software C   | 2022-01-01  | 2023-01-01  | annual            |
| 14              | 4           | Software D   | 2022-05-01  | 2023-05-01  | annual            |

**Write a PostgreSQL query that produces a list of customers (first & last names) who currently have an active annual subscription.**

**Solution:**

```sql
SELECT c.first_name, c.last_name 
FROM   customers as c JOIN subscriptions as s USING(customer_id)
WHERE  s.subscription_type = 'annual' AND s.start_date <= CURRENT_DATE AND s.end_date >= CURRENT_DATE;
```

---

### 3. What's the difference between a unique index and non-unique index?

**Answer:**

**Unique indexes** help ensure that there are no duplicate key values in a table, maintaining data integrity. They enforce uniqueness whenever keys are added or changed within the index.

**Non-unique indexes** on the other hand, are used to improve query performance by maintaining a sorted order of frequently used data values, but they do not enforce constraints on the associated table.

Unique Indexes are blazing fast. Non unique indexes can improve query performance, but they are often slower because of their non-unique nature.

### 4. Average Response Time By Application

Dynatrace provides software intelligence to simplify cloud complexity and accelerate digital transformation. For our question, let's consider that they wish to analyze the average response time of their applications.

Imagine you are a data analyst at Dynatrace. The team needs to know the average response time for each application, grouped by application ID and sorted by average response time in ascending order.

**Example Input:**

`application_logs` Table:

| log_id | application_id | response_time | timestamp           |
|--------|----------------|---------------|----------------------|
| 7953   | 101            | 1200          | 2022-07-01 10:00:00  |
| 8197   | 102            | 800           | 2022-07-01 11:00:00  |
| 6784   | 101            | 1000          | 2022-07-01 12:00:00  |
| 7234   | 103            | 1500          | 2022-07-01 13:00:00  |
| 7627   | 101            | 1300          | 2022-07-01 14:00:00  |

**Write a SQL query that fetches the average response time for each application.**

**Solution:**

```sql
SELECT   application_id, 
         AVG(response_time) as avg_response_time
FROM     application_logs
GROUP BY 1
ORDER BY 2
```

---

### 5. How can you select records without duplicates from a table?

**Answer:**

The `DISTINCT` clause in SQL allows you to select records that are unique, eliminating duplicates.

For a tangible example, say you had a table of Dynatrace employees:


first_name | job_title
------------|-------------
Akash      | Data Analyst
Brittany   | Data Scientist
Carlos     | Data Engineer
Diego      | Data Engineer
Eva        | Data Analyst


If you were doing an HR Analytics project and you wanted to get all the unique job titles that currently worked at the company, you would write the following SQL query:

```sql
SELECT DISTINCT job_title 
FROM   dynatrace_employees
```

The output would give you 3 distinct job titles at Dynatrace:


job_title |
------------- |
Data Analyst |
Data Scientist |
Data Engineer |

---

### 6. Search for all Products with Name beginning with "Dyn"

As Dynatrace, we serve various products to our customers. Some product names start with the word "Dyn".

You are tasked with designing a SQL query that would list out all the customers who bought any product beginning with the word "Dyn".

**Example Input:**

`customers` Table:

| customer_id | customer_name | email               |
|-------------|---------------|---------------------|
| 1001        | John Doe      | johndoe@example.com |
| 1002        | Jane Doe      | janedoe@example.com |
| 1003        | Sam Smith     | samsmith@example.com|

`products` Table:

| product_id | product_name             | price   |
|------------|--------------------------|---------|
| 50001      | Dynatrace Monitoring Tool| 500.90  |
| 50002      | Dynatrace Log Analyzer   | 200.40  |
| 50003      | Other Software Tool      | 300.45  |

`customer_products` Table:

| customer_id | product_id |
|-------------|------------|
| 1001        | 50001      |
| 1002        | 50002      |
| 1003        | 50003      |
| 1001        | 50003      |
| 1002        | 50001      |

**Solution:**

```sql
SELECT c.customer_name, c.email, p.product_name
FROM   customers c JOIN customer_products cp USING(customer_id)
                   JOIN products p USING(product_id)
WHERE  p.product_name LIKE 'Dyn%';
```
---

### 7. What's the SQL command INTERSECT do, and can you give an example?

**Answer:**

Similar to the `UNION` and `EXCEPT`/`MINUS` operators, the PostgreSQL `INTERSECT` operator combines result sets of two or more `SELECT` statements into a single result set. However, `INTERSECT` only returns the rows that are in BOTH select statements.

For a concrete example, say you were on the Sales Analytics team at Dynatrace, and had data on sales leads exported from both HubSpot and Salesforce CRMs in two different tables. To write a query to analyze leads created after 2023 started, that show up in both CRMs, you would use the `INTERSECT` command:

```sql
SELECT email, job_title, company_id
FROM   dynatrace_hubspot_leads
WHERE  created_at > '2023-01-01'

INTERSECT

SELECT email, job_title, company_id 
FROM   dynatrace_sfdc_leads
WHERE  created_at > '2023-01-01';
```
---

### 8. Joining and Analyzing customer and orders databases

**Description:**

For Dynatrace company, we want to analyze the ordering habits of customers. Therefore, we have a `customers` table to hold customer data and an `orders` table to keep track of their orders.

**Example Input:**

`customers` Table:

| customer_id | first_name | last_name | signup_date | location |
|-------------|------------|-----------|-------------|----------|
| 9871        | John       | Doe       | 01/01/2022  | New York |
| 8702        | Emily      | Blankenship| 02/10/2022 | California|
| 5298        | Clark      | Smith     | 03/15/2022  | Texas    |
| 6523        | Ava        | Johnson   | 04/26/2022  | Florida  |
| 4512        | James      | Brown     | 05/05/2022  | Alaska   |

`orders` Table:

| order_id | order_date | product           | quantity | customer_id |
|----------|------------|-------------------|----------|-------------|
| 16171    | 06/08/2022 | Dynatrace Software| 1         | 9871        |
| 17802    | 06/10/2022 | IT Solutions      | 2         | 8702        |
| 15293    | 06/18/2022 | Cybersecurity Service| 1       | 5298        |
| 16352    | 07/26/2022 | Dynatrace Software| 1         | 6523        |
| 14517    | 07/05/2022 | Data Analysis     | 1         | 4512        |

**Write a SQL query that returns each customer's first and last name, along with the total quantity of all their orders.**

**Solution:**

```sql
SELECT   c.first_name, c.last_name, SUM(o.quantity) as total_quantity
FROM     customers c JOIN orders o USING(customer_id)
GROUP BY 1, 2
```

---

### 9. Calculate Risk Score for Server Instances

**Description:**

Dynatrace, a software intelligence company, maintains a database of server instances that they monitor for their customers. Each server instance has associated metrics like CPU usage, Memory usage, Disk usage, and Network usage. These metrics are updated every minute. 

You have to write a SQL query that calculates a "**risk score**" for each server based on the following conditions:

1. The risk score for a server is calculated as the sum of the following:

    - The square root of the average CPU usage over the past hour.

    - The absolute value difference between the maximum memory usage and minimum memory usage over the past hour.
    - The modulo of the sum of the disk usage and network usage over the past hour with 100.
    - The power of the average network usage over the past hour raised to 2.

2. Round the final risk score to 2 decimal places.

3. Only include servers which have a CPU usage over 70 within the past hour.

**Example Input:**

`server_metrics` Table:

| server_id | time_stamp             | cpu_usage (%) | mem_usage (%) | disk_usage (GB) | network_usage (MB) |
|-----------|------------------------|---------------|---------------|-----------------|-------------------|
| 1025      | 2022-07-28 11:00:00    | 85            | 50            | 120             | 500               |
| 1025      | 2022-07-28 11:01:00    | 80            | 55            | 121             | 600               |
| 2012      | 2022-07-28 11:00:00    | 65            | 70            | 200             | 400               |
| 2012      | 2022-07-28 11:01:00    | 75            | 75            | 201             | 500               |
| 3001      | 2022-07-28 11:00:00    | 80            | 60            | 150             | 600               |
| 3001      | 2022-07-28 11:01:00    | 70            | 65            | 151             | 700               |

**Solution:**

```sql
SELECT   server_id,
         ROUND( SQRT(AVG(cpu_usage)) + ABS(MAX(mem_usage) - MIN(mem_usage)) + ((SUM(disk_usage) + SUM(network_usage)) % 100) + POWER(AVG(network_usage), 2)
         , 2) as risk_score
FROM     server_metrics
WHERE    time_stamp BETWEEN NOW() - INTERVAL '1 hour' AND NOW() 
GROUP BY server_id
HAVING   MAX(cpu_usage) > 70;
```

---