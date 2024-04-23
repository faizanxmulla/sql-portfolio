## 10 Datadog SQL Interview Questions

### 1. Average Performance Score by Server and Hour

Let's imagine you are a Data Analyst at Datadog, a monitoring service for cloud-scale applications. Datadog has a metric called `performance_score` which measures the performance of different servers.  

Each server has an associated `server_id`. The performance score of each server is recorded every hour, and the `timestamp` of the measure is in timestamp field. All these details are recorded in a table called `server_metrics`.

The task is to :

**Write a SQL query that can identify trends in server performance. Specifically, calculate the average performance_score of each server (server_id) for each hour of the day, using window functions.**

`server_metrics` Example Input:

| record_id | server_id | timestamp           | performance_score |
|-----------|-----------|----------------------|-------------------|
| 1         | 101       | 2022-07-01 01:00:00 | 80                |
| 2         | 101       | 2022-07-01 02:00:00 | 88                |
| 3         | 102       | 2022-07-02 01:00:00 | 82                |
| 4         | 102       | 2022-07-02 02:00:00 | 90                |
| 5         | 101       | 2022-07-02 01:00:00 | 85                |
| 6         | 102       | 2022-07-03 02:00:00 | 91                |

#### Solution:

```sql
SELECT   server_id,
         EXTRACT(HOUR FROM timestamp) as hour_of_day,
         AVG(performance_score) OVER (PARTITION BY server_id, EXTRACT(HOUR FROM timestamp)) as   avg_performance_score
FROM     server_metrics
ORDER BY 1, 2
```


---

### 2. Filtering Customer's Data

Datadog records customer interactions in two tables: customer_info for general customer information, and customer_interactions for touchpoints with each customer (e.g., technical support, sales calls etc.). 

**Write a PostgreSQL query to retrieve a list of all customers (customer_id and customer_name) based in 'USA' who have had more than ten interactions in the last six months.**

`customer_info` Example Input:

| customer_id | customer_name   | location |
|-------------|-----------------|----------|
| 1           | ABC Inc.        | USA      |
| 2           | DEF LLC         | Canada   |
| 3           | XYZ Corporation | USA      |
| 4           | HIJ AG          | Germany  |

`customer_interactions` Example Input:

| interaction_id | customer_id | interaction_date |
|----------------|-------------|-------------------|
| 1001           | 1           | 2022-01-21        |
| 1002           | 1           | 2022-02-11        |
| 1003           | 2           | 2022-03-08        |
| 1004           | 1           | 2022-04-07        |
| 1005           | 1           | 2022-05-06        |
| 1006           | 3           | 2022-06-05        |
| 1007           | 3           | 2022-05-12        |
| 1008           | 1           | 2022-04-20        |
| 1009           | 1           | 2022-03-13        |
| 1010           | 1           | 2022-02-22        |
| 1011           | 1           | 2022-01-10        |
| 1012           | 3           | 2022-02-02        |
| 1013           | 2           | 2022-04-12        |
| 1014           | 2           | 2022-05-22        |
| 1015           | 1           | 2022-06-01        |
| 1016           | 1           | 2022-06-18        |

#### Solution:

```sql
-- my solution (using CTE): 

WITH cte as (
    SELECT   customer_id, count(interaction_id) as interaction_count
    FROM     customer_interactions
    WHERE    interaction_date <= CURRENT_DATE - interval '6 months'
    GROUP BY 1  
)
SELECT customer_id, customer_name
FROM   cte JOIN customer_info as c USING(customer_id)
WHERE  interaction_count > 10 and location='USA'


-- alternate solution (using SUBQUERY): 

SELECT ci.customer_id, ci.customer_name
FROM   customer_info ci JOIN (
  SELECT   customer_id 
  FROM     customer_interactions
  WHERE    interaction_date > CURRENT_DATE - INTERVAL '6 months'
  GROUP BY 1
  HAVING   COUNT(interaction_id) > 10
) ci2 USING(customer_id)
WHERE  ci.location = 'USA';
```



---

### 3. Why are foreign key's important in databases?

A foreign key is a field in a database table that serves as a reference to the primary key of another table, allowing for the creation of a relationship between the two tables.

For a concrete example, let's inspect employee data from Datadog's HR database:

`datadog_employees`:

| employee_id | first_name | last_name | manager_id |
|-------------|------------|------------|------------|
| 1           | Aubrey     | Graham     | 3          |
| 2           | Marshal    | Mathers    | 3          |
| 3           | Dwayne     | Carter     | 4          |
| 4           | Shawn      | Carter     |            |

In this table, employee_id is the primary key, and is used to uniquely identify each row.

`manager_id` could be a foreign key. It references the employee_id of the manager of each employee in the table, establishing a relationship between the employees and their managers. 

This foreign key allows you to easily query the table to find out who a specific employee's manager is, or to find out which employees report to a specific manager.

It is possible for a table to have multiple foreign keys that reference primary keys in different tables. 

For instance, the datadog_employees table could have additional foreign keys for the department_id of the department where an employee works and the location_id of the employee's location.

---

### 4. Computing Click-through and Conversion Rates for Datadog's Digital Products

Datadog has a range of digital products which they continually market through various channels. Given the tables clicks that records every time a user clicks on one of Datadog's ads, and conversions that records every time a user goes from viewing a product to adding it into their cart, write a SQL query that would be able to calculate the click-through rate (CTR) and the conversion rate (Conversion Rate) for the source 'Facebook' in December 2022.

`clicks` Example Input:

| click_id | user_id | click_time          | product_id | source        |
|----------|---------|----------------------|------------|----------------|
| 8731     | 654     | 12/02/2022 08:15:00 | 301        | Facebook       |
| 9932     | 850     | 12/07/2022 16:45:00 | 909        | Google Ads     |
| 7533     | 964     | 12/14/2022 12:00:00 | 301        | Facebook       |
| 1632     | 778     | 12/19/2022 10:00:00 | 909        | Direct Traffic |
| 2974     | 125     | 12/23/2022 16:03:00 | 301        | Facebook       |

`conversions` Example Input:

| conversion_id | user_id | conversion_time     | product_id |
|---------------|---------|----------------------|------------|
| 2671          | 654     | 12/02/2022 08:25:00 | 301        |
| 7822          | 850     | 12/08/2022 09:30:00 | 909        |
| 5213          | 964     | 12/15/2022 12:10:00 | 301        |
| 6132          | 778     | 12/20/2022 10:30:00 | 909        |
| 4287          | 125     | 12/23/2022 16:30:00 | 301        |

#### Solution:

```sql
SELECT   source, 
         COUNT(click_id) AS total_clicks, 
         COUNT(conversion_id) AS total_conversions, 
         COUNT(conversion_id) / COUNT(click_id)::float AS conversion_rate,
         EXTRACT(MONTH FROM click_time) AS month
FROM     clicks c LEFT JOIN conversions co ON c.user_id = co.user_id AND c.product_id = co.product_id
WHERE    EXTRACT(YEAR FROM click_time)='2022' AND EXTRACT(MONTH FROM click_time)='12' AND source = 'Facebook'
GROUP BY 1, month
```

---

### 5. What's the purpose of the COALESCE() function in SQL?

The COALESCE() function is used to remove NULLs, and replace them with another value.

For example, say you were a Data Analyst at Datadog and were doing a customer analytics project to see who the most marketing-engaged customers were, and had access to the below table.

`datadog_customers`:

| customer_id | email_engagement | sms_engagement |
|-------------|-------------------|-----------------|
| 101         | very_active       | not_opted_in    |
| 201         | un-subscribed     | NULL            |
| 301         | NULL              | not_opted_in    |
| 401         | not_active        | very_active     |
| 501         | very_active       | mildly_active   |
| 303         | NULL              | NULL            |

Before you could procede, you had to remove the NULLs, and replace them with the default value (not_active for email, and not_opted_in for SMS). To do this, you'd run the following query:

```sql
SELECT customer_id, 
       COALESCE(email_engagement, "not_active") as email_engagement,
       COALESCE(sms_engagement, "not_opted_in") as sms_engagement
FROM   datadog_customers;
```

This would get you the following output:

| customer_id | email_engagement | sms_engagement |
|-------------|-------------------|-----------------|
| 101         | very_active       | not_opted_in    |
| 201         | un-subscribed     | not_opted_in    |
| 301         | not_active        | not_opted_in    |
| 401         | not_active        | very_active     |
| 501         | very_active       | mildly_active   |
| 303         | not_active        | not_opted_in    |

---

### 6. Average response time per service

Datadog is a monitoring and analytics platform for developers, IT operations teams, and business users. 

Let's take the example where we need to examine the average response times of the APIs for different services sampled at various timestamps.

In this case, the tables will have the following structure:

`api_logs` Example Input:

| log_id | timestamp           | service_name | api_name     | response_time |
|--------|----------------------|--------------|---------------|---------------|
| 1      | 2022-10-01 00:00:00 | Payment      | CreatePayment| 500           |
| 2      | 2022-10-01 00:01:00 | Payment      | CreatePayment| 600           |
| 3      | 2022-10-01 00:02:00 | Order        | CreateOrder  | 300           |
| 4      | 2022-10-01 00:03:00 | Order        | CreateOrder  | 450           |
| 5      | 2022-10-01 00:04:00 | Order        | GetOrder     | 600           |

You are required to find the average response time of each service in the 'api_logs' table.

Example Output:

| service_name | avg_response_time |
|--------------|-------------------|
| Payment      | 550               |
| Order        | 450               |

#### Solution:

```sql
SELECT   service_name, AVG(response_time) as avg_response_time
FROM     api_logs
GROUP BY 1
```

---

### 7. Can you give an example of a one-to-one relationship between two entities, vs. a one-to-many relationship?

In database schema design, a **one-to-one relationship** between two entities is characterized by each entity being related to a single instance of the other. An example of this is the relationship between a US citizen and their social-security number (SSN) - each citizen has one SSN, and each SSN belongs to one person.

On the other hand, a **one-to-many relationship** is when one entity can be associated with multiple instances of the other entity. A teacher's relationship with their classes is an example of this - a teacher can teach many classes, but each class is only associated with one teacher.

---

### 8. Find Client Information with Specific Patterns

In the Datadog's customer records database, it is crucial to find certain patterns in the client's email domain to understand the type and spread of clients. Write a SQL query that will allow us to retrieve all records of clients whose email domain is 'gmail.com'.

Assume that we have the following `clients` table:

`clients` Example Input:

| client_id | first_name | last_name | email                  |
|-----------|------------|------------|------------------------|
| JD01      | John       | Doe       | john.doe@gmail.com      |
| AD02      | Alice      | Davis     | alice.davis@yahoo.com   |
| MS03      | Mark       | Smith     | mark.smith@gmail.com    |
| JH04      | Jane       | Hudson    | jane.hudson@hotmail.com |
| RS05      | Rebecca    | Simpson   | rebecca.simpson@gmail.com |

Your task is to pull out the client_id, first_name, last_name and email of clients using 'gmail.com' as their email domain.

#### Solution:

```sql
SELECT *
FROM   clients
WHERE  email LIKE '%gmail.com';
```


---

### 9. Calculating Rajon's Performance Metrics

Rajon is a service engineer at Datadog, and he works in shifts. He keeps a record of his work periods and the number of errors he finds during his work sessions. We want to calculate Rajon's work efficiency in terms of errors found per hour.

For this, we have a `shifts` table where each row indicates a shift Rajon has worked, the start and end times of his shifts (in the format HH:MM:SS), and the number of errors found during that shift.

`shifts` Example Input:

| shift_id | start_time | end_time | errors_found |
|----------|------------|----------|--------------|
| 1001     | 08:00:00   | 10:00:00 | 4            |
| 1012     | 12:00:00   | 18:00:00 | 9            |
3991 |	22:00:00 |	06:00:00 |	7 |
5804 |	13:00:00 |	21:00:00 |	6 |
6123 |	08:00:00 |	16:00:00 |	5 |


**Write a PostgreSQL query to calculate the working hours for each shift (considering the fact that some shifts span two days), calculate the number of errors found per hour, and round the result to two decimal places.**

#### Solution:

```sql
SELECT shift_id,
       errors_found, 
       EXTRACT(EPOCH FROM (CASE 
                               WHEN start_time < end_time THEN end_time - start_time 
                               ELSE end_time + INTERVAL '1 day' - start_time 
                           END)) / 3600 AS working_hours,
       ROUND(errors_found / EXTRACT(EPOCH FROM (CASE 
                                                     WHEN start_time < end_time THEN end_time - start_time 
                                                     ELSE end_time + INTERVAL '1 day' - start_time 
                                                END)) * 3600, 2) AS errors_per_hour
FROM   shifts;
```


---

### 10. What's the difference between a unique index and non-unique index?

**Unique indexes** help ensure that there are no duplicate key values in a table, maintaining data integrity. They enforce uniqueness whenever keys are added or changed within the index.

To define a unique index in PostgreSQL, you can use the following syntax:

```sql
CREATE UNIQUE INDEX index_name
ON table_name (column_name);
```

To define a non-unique index in PostgreSQL, you can use the following syntax:

**Non-unique indexes** on the other hand, are used to improve query performance by maintaining a sorted order of frequently used data values, but they do not enforce constraints on the associated table.

```sql
CREATE INDEX user_name_index
ON users (name);
```

---