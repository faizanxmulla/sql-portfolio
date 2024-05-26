## 10 Splunk SQL Interview Questions


### 1. Identify the Most Active Splunk Users

Splunk is a data platform mainly used for searching, monitoring, and examining machine-generated big data, via a web-style interface. Users log into the system and perform various tasks such as creating dashboards, running searches, or setting alerts.

One way to identify power users on Splunk can be to calculate who executes most activities in the system. For this question, assume that an activity is a search activity given this is the core function of Splunk. 

Power users are defined as the top 10% users who execute most searches on the platform.

Given two tables "users" and "searches", write a SQL query to list out the power users. 

The "users" table includes basic user info and the "searches" table contains all search activities performed by the users.

**Example Input:**

`users` table:

| user_id | first_name | last_name | role    |
|---------|------------|-----------|---------|
| 1       | John       | Doe       | Analyst |
| 2       | Jane       | Smith     | Manager |
| 3       | Mark       | Cuban     | Engineer|

`searches` table:

| search_id | user_id | search_time          | search_string     |
|-----------|---------|----------------------|-------------------|
| 100       | 1       | 06/08/2022 00:00:00  | "error code 500"  |
| 101       | 2       | 06/10/2022 00:00:00  | "server down"     |
| 102       | 1       | 06/18/2022 00:00:00  | "CPU usage"       |
| 103       | 3       | 07/26/2022 00:00:00  | "log file not found" |
| 104       | 2       | 07/05/2022 00:00:00  | "disk space"      |
| 105       | 1       | 07/08/2022 00:00:00  | "error code 404"  |
| 106       | 2       | 07/10/2022 00:00:00  | "server up"       |

**Answer:**

```sql
WITH searches_cte as (
    SELECT   user_id, COUNT(search_id) AS cnt
    FROM     searches
    GROUP BY 1
),
percentile_cte as (
    SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY cnt desc)
    FROM   searches_cte
),
power_users_cte as (
    SELECT user_id, cnt
    FROM   searches_cte 
    WHERE  cnt >= (SELECT *
                   FROM   percentile_cte)
)
SELECT p.*
FROM   power_users_cte p JOIN users u USING(user_id)
```


---

### 2. Calculate Average Login Time per User

Assume you have been provided with a database table named "user_login" which stores event logs whenever users log in to Splunk. The table columns are as follows: `user_id`, `login_time` (in datetime format).

Your task is to write a SQL window function to calculate the average time between consecutive logins for each user. For simplicity, let's assume it's sufficient to calculate the average over all users' second-to-last login to their most recent login.

**Example Input:**

`user_login` table:

| login_id | user_id | login_time          |
|----------|---------|----------------------|
| 1        | 001     | 01/08/2022 08:25:10 |
| 2        | 002     | 01/08/2022 09:10:00 |
| 3        | 001     | 01/09/2022 07:30:15 |
| 4        | 003     | 01/09/2022 07:30:17 |
| 5        | 002     | 01/10/2022 10:00:00 |
| 6        | 001     | 01/10/2022 08:30:20 |

**Example Output:**

| user_id | avg_login_interval |
|---------|---------------------|
| 001     | 1 days 00:02:35     |
| 002     | 2 days 00:50:00     |

**Answer:**

```sql
WITH login_interval_cte as (
    SELECT user_id, 
           login_time - LAG(login_time) over(PARTITION BY user_id ORDER BY login_time) as login_interval
    FROM   user_login
)
SELECT   DISTINCT user_id, 
         AVG(login_interval) OVER(PARTITION BY user_id) as avg_time_between_logins
FROM     login_interval_cte
ORDER BY 1
```


---

### 3. What does it mean to perform a self-join?

**Answer:**
A self-join is a JOIN operation in which a single table is joined to itself. To perform a self-join, you must specify the table name twice in the FROM clause, giving each instance a different alias. You can then join the two instances of the table using a JOIN clause, and specify the relationship between the rows in a WHERE clause.

Think of using a self-joins whenever your data analysis involves analyzing pairs of the same things, like comparing the salaries of employees within the same department, or identifying pairs of products that are frequently purchased together.

For another self-join example, suppose you were conducting an HR analytics project and needed to examine how frequently employees within the same department at Splunk interact with one another, you could use a self-join query like the following to retrieve all pairs of Splunk employees who work in the same department:

```sql
SELECT e1.name AS employee1, e2.name AS employee2
FROM   splunk_employees AS e1 JOIN splunk_employees AS e2 USING(department_id)
WHERE  e1.id <> e2.id;
```



---

### 4. Filter Splunk Customers Based on Various Conditions

Splunk Inc. provides innovative software solutions to manage and analyze data. As part of their operations, they want to filter their customers who are based in the US and have a lifetime subscription with the company. They also want to exclude customers with active support tickets.

Given the `customers` table, write an SQL query to achieve this. Filters should be on the `country`, `subscription_type`, and `active_tickets` fields.

**Example Input:**

`customers` table:

| customer_id | first_name | last_name | country | subscription_type | active_tickets |
|-------------|------------|------------|---------|-------------------|----------------|
| 101         | Robert     | Smith      | US      | Monthly           | 0              |
| 102         | Jane       | Doe        | US      | Lifetime          | 0              |
| 103         | Tom        | Brown      | CA      | Lifetime          | 1              |
| 104         | Julia      | Cook       | US      | Lifetime          | 0              |
| 105         | John       | Green      | US      | Lifetime          | 3              |

**Example Output:**

| customer_id | first_name | last_name | country | subscription_type | active_tickets |
|-------------|------------|------------|---------|-------------------|----------------|
| 102         | Jane       | Doe        | US      | Lifetime          | 0              |

**Answer:**

```sql
SELECT *
FROM   customers
WHERE  country = 'US' AND 
       subscription_type = 'Lifetime' AND
       active_tickets = 0;
```


---

### 5. What's the difference between HAVING and WHERE?

**Answer:**
The `HAVING` clause works similarly to the `WHERE` clause, but it is used to filter the groups of rows created by the `GROUP BY` clause rather than the rows of the table themselves.

For example, say you were analyzing Splunk sales data:

```sql
SELECT   region, SUM(sales)
FROM     splunk_sales
WHERE    date > '2023-01-01'
GROUP BY 1
HAVING   SUM(sales) > 500000;
```



---

### 6. Average Number of Logs per Server

In the company Splunk, which primarily deals with big data and its analysis through their proprietary tool, you might be asked to find the average number of logs generated per server on a daily basis. This is a realistic problem, as understanding how much data your servers are generating can be important for optimizing resources, spotting anomalies, and understanding the health of your systems.

Assume you have access to a `log_data` table, which contains information about every log entry generated by their system.

**Example Input:**

`logs` table:

| log_id | server_id | log_timestamp       | log_type    |
|--------|-----------|----------------------|-------------|
| 10001  | 1         | 2022-07-10T08:30:00Z| Error       |
| 10002  | 1         | 2022-07-10T08:45:00Z| Warning     |
| 10003  | 2         | 2022-07-10T09:00:00Z| Information |
| 10004  | 2         | 2022-07-10T09:15:00Z| Error       |
| 10005  | 2         | 2022-07-10T09:30:00Z| Information |
| 10006  | 3         | 2022-07-10T09:45:00Z| Warning     |
| 10007  | 3         | 2022-07-10T10:00:00Z| Error       |
| 10008  | 3         | 2022-07-10T10:15:00Z| Warning     |
| 10009  | 1         | 2022-07-10T10:30:00Z| Information |

The task:

**Write a SQL query which calculates the average number of logs generated by each server on a daily basis.**

**Answer:**

```sql
SELECT   server_id,
         DATE(log_timestamp) AS day,
         AVG(COUNT(log_id)) OVER(PARTITION BY server_id, DATE(log_timestamp)) as avg_logs
FROM     logs
GROUP BY 1, 2
```


---

### 7. Can you explain the distinction between a clustered and a non-clustered index?

**Answer:**
Here is an example of a clustered index on the `transaction_id` column of a table of Splunk customer transactions:

```sql
CREATE CLUSTERED INDEX transaction_id_index
ON splunk_transactions (transaction_id);
```

This creates a clustered index on the `transaction_id` column, which will determine the physical order of the data rows in the table.

Here is an example of a non-clustered index on the `transaction_id` column of the same table:

```sql
CREATE INDEX transaction_id_index
ON splunk_transactions (transaction_id);
```

This will create a non-clustered index on the `transaction_id` column, which will not affect the physical order of the data rows in the table.

In terms of query performance, a clustered index is usually faster for searches that return a large number of records, while a non-clustered index is faster for searches that return a small number of records. 

However, updates to a clustered index are slower, as they require the data rows to be physically rearranged, while updates to a non-clustered index are faster, as they only require the index data structure to be updated.

---

### 8. Calculate Average Data Ingested

As a data engineer at Splunk, you primarily deal with log management and analysis for clients. You have a table `log_data` recording the daily amount of data ingested from various client's systems. 

Your task is to **compute the average daily data ingested per client, per month, and sorted by client name and month.**

**Example Input:**

`log_data` table:

| log_id | client_name | ingest_date | data_size_GB |
|--------|-------------|--------------|--------------|
| 101    | Client_A    | 04/02/2022   | 20.5         |
| 102    | Client_A    | 04/05/2022   | 23.1         |
| 103    | Client_B    | 04/04/2022   | 19.2         |
| 104    | Client_B    | 04/10/2022   | 24.3         |
| 105    | Client_A    | 05/01/2022   | 22.6         |
| 106    | Client_B    | 05/03/2022   | 21.5         |
| 107    | Client_A    | 05/10/2022   | 25.7         |
| 108    | Client_B    | 05/15/2022   | 20.4         |

**Example Output:**

| month | client_name | avg_data_size_GB |
|-------|-------------|-------------------|
| 4     | Client_A    | 21.8              |
| 4     | Client_B    | 21.75             |
| 5     | Client_A    | 24.15             |
| 5     | Client_B    | 20.95             |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM ingest_date) AS month,
         client_name, 
         AVG(data_size_GB) as avg_data_size_GB
FROM     log_data
GROUP BY 1, 2
ORDER BY 1, 2
```


### 9. Analyze Revenue and Customer Activities

Analyze the revenue and customer activities of Splunk. Assume we have two tables: `purchases` and `users`. 

The `purchases` table contains records of all purchases, with the `user_id` of the customer who made the purchase, the `purchase_date`, and the `price` of the product the customer bought. 

The `users` table contains information about each user, with fields for `user_id`, `first_name` and `last_name`.

Write a SQL query that retrieves all the purchases made by customers whose last names start with the letter 'S', and return the `first_name`, `last_name`, total number of purchases and total revenue for each of these customers, ordered by `total_revenue` in descending order.


**Example Input:**

`purchases` table:

| purchase_id | user_id | purchase_date | price |
|-------------|---------|----------------|-------|
| 101         | 001     | 01/10/2022     | 99.99 |
| 102         | 002     | 01/12/2022     | 49.50 |
| 103         | 003     | 01/14/2022     | 29.90 |
| 104         | 001     | 01/17/2022     | 79.99 |
| 105         | 003     | 01/20/2022     | 69.90 |

`users` table:

| user_id | first_name | last_name |
|---------|------------|-----------|
| 001     | Steve      | Smith     |
| 002     | Raj        | Singh     |
| 003     | Millie     | Salzano   |

**Answer:**

```sql
SELECT   CONCAT(u.first_name, ' ', u.last_name), 
         COUNT(p.purchase_id) AS total_purchases, 
         SUM(p.price) AS total_revenue
FROM     users u JOIN purchases p USING(user_id)
WHERE    u.last_name LIKE 'S%'
GROUP BY u.user_id
ORDER BY 3 DESC;
```



--- 

### 10. What are stored procedures, and why are they useful?

**Answer:**
Stored procedures are like functions in Python – they can accept input params and return values, and are used to encapsulate complex logic.

For example, if you worked as a Data Analyst in support of the Marketing Analytics team at Splunk, a common task might be to find the conversion rate for your ads given a specific time-frame. Instead of having to write this query over-and-over again, you could write a stored procedure like the following:

```sql
CREATE FUNCTION get_conversion_rate(start_date DATE, end_date DATE, event_name TEXT)
RETURNS NUMERIC AS
$BODY$
BEGIN
  RETURN (SELECT COUNT(*) FROM events WHERE event_date BETWEEN start_date AND end_date AND event_name = 'conversion')
          / (SELECT COUNT(*) FROM events WHERE event_date BETWEEN start_date AND end_date AND event_name = 'impression');
END;
$BODY$
LANGUAGE 'plpgsql';
```

To call this stored procedure, you'd execute the following query:

```sql
SELECT get_conversion_rate('2023-01-01', '2023-01-31', 'conversion');
```

Stored procedures are useful because they allow you to encapsulate complex logic in a reusable way, promote code reuse, and can improve performance by pre-compiling the code and caching the execution plan.

---