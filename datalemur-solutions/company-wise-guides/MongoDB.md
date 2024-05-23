## 11 MongoDB SQL Interview Questions


### 1. Identifying MongoDB Power Users

MongoDB often identifies its power users or VIPs as users who are making a high number of read and write operations. 

Let's say a power user is defined as a user who makes more than 5000 operations in a single day. 

**Write a SQL query to find all the power users that exist in the database based on their daily operations.**

The database contains two tables - `users` and `operations`: 

- The `users` table contains information about each user, with columns for 'user_id' and 'user_name'. 

- The `operations` table records each operation made by a user, with columns for 'op_id', 'user_id', 'operation_type' ('read' or 'write') and 'op_time' (timestamp of when the operation was made).

`users` **Example Input:**

| user_id | user_name |
|---------|-----------|
| 1       | Jake      |
| 2       | Amy       |
| 3       | Rosa      |
| 4       | Terry     |
| 5       | Raymond   |


`operations` **Example Input:**

| op_id | user_id | operation_type | op_time              |
|-------|---------|-----------------|----------------------|
| 101   | 1       | read            | 06/08/2022 00:00:00 |
| 102   | 1       | write           | 06/08/2022 00:01:00 |
| 103   | 1       | read            | 06/08/2022 00:02:00 |
| 104   | 2       | write           | 06/10/2022 00:00:00 |
| 105   | 2       | read            | 06/10/2022 00:01:00 |

**Answer:**

```sql
SELECT   user_name, COUNT(op_id) AS operation_count
FROM     users u JOIN operations o USING(user_id)
WHERE    op_time::date = '2022-06-08'
GROUP BY 1
HAVING   COUNT(op_id) > 5000;
```

---

### 2. Find the Average Star Rating Per Month for Each Product

Write a SQL query to find the average stars given by users for each product for each month in the year 2022. 

For simplicity, assume that each review is uniquely identified by review_id, and each user and product is uniquely identified by user_id and product_id, respectively.

You are provided with the following reviews table:

`reviews` **Example Input:**

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|--------------|------------|-------|
| 6171      | 123     | 2022-06-08  | 50001      | 4     |
| 7802      | 265     | 2022-06-10  | 69852      | 4     |
| 5293      | 362     | 2022-06-18  | 50001      | 3     |
| 6352      | 192     | 2022-07-26  | 69852      | 3     |
| 4517      | 981     | 2022-07-05  | 69852      | 2     |

**Write a SQL query to find the average star rating given to each product per month.** 

The date is given in the format 'YYYY-MM-DD'.

**Example Output:**

| mth | product_id | avg_stars |
|-----|------------|----------:|
| 6   | 50001      |      3.50 |
| 6   | 69852      |      4.00 |
| 7   | 69852      |      2.50 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) as mth,
         product_id,
         AVG(stars) as avg_stars
FROM     reviews
WHERE    EXTRACT(YEAR FROM submit_date) = 2022
GROUP BY 1, 2
ORDER BY 1, 2;
```

---

### 3. What would you do to speed up a slow SQL query?

First things first, figure out why the query is slow! You can use ANALYZE and EXPLAIN commands in PostgreSQL to identify any performance bottlenecks. You might discover that your query is inefficient, or that there are many database writes at the same time you are doing a read, or maybe too many people are concurrently running queries on the same database server.

For Data Analyst and Data Science positions, knowing the ins-and-outs of SQL performance tuning is out-of-scope for the SQL interview round. However, knowing that joins are expensive, and indexes can speed up queries, is generally enough of an answer for MongoDB SQL interviews.

---

### 4. Analyzing Customer Query Trends

MongoDB Inc. is interested in better understanding how their customers are using their product. 

Specifically, they want to know which of their top database products (Product A, B, C, D, E) are queried most often by users per day. 

This information will help the company prioritize developing new features and improvements for the most popular products.

To conduct this analysis, you have access to two tables in their PostgreSQL database, `user_queries` and `user_products`.

`user_queries` **Example Input:**

| query_id | user_id | query_time           | query_text                    |
|----------|---------|----------------------|--------------------------------|
| 1        | 100     | 2022-08-12 09:12:33 | 'SELECT * FROM product_a'     |
| 2        | 150     | 2022-08-12 10:22:02 | 'UPDATE product_a SET...'      |
| 3        | 120     | 2022-08-13 11:33:44 | 'DELETE FROM product_b WHERE...'|
| 4        | 100     | 2022-08-13 18:45:52 | 'INSERT INTO product_c VALUES...'|
| 5        | 150     | 2022-08-14 07:25:22 | 'SELECT * FROM product_d'     |

`user_products` **Example Input:**

| user_id | product_name |
|---------|---------------|
| 100     | 'Product A'   |
| 150     | 'Product B'   |
| 120     | 'Product C'   |
| 100     | 'Product D'   |
| 150     | 'Product E'   |

**Write a SQL query in PostgreSQL to calculate the total queries for each product per day.**

**Answer:**

```sql
SELECT   DATE(query_time) as query_date, 
         product_name, 
         COUNT(*) as total_queries
FROM     user_queries as q JOIN user_products as p USING(user_id)
WHERE    query_text LIKE CONCAT('%', product_name, '%')
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
```

---

### 5. What is the difference between cross join and natural join?

**Cross joins** and **natural joins** are two types of JOIN operations in SQL that are used to combine data from multiple tables. 

A `cross join` creates a new table by combining each row from the first table with every row from the second table, and is also known as a cartesian join. 

On the other hand, a `natural join` combines rows from two or more tables based on their common columns, forming a new table. One key difference between these types of JOINs is that cross joins do not require common columns between the tables being joined, while natural joins do.

Here's an example of a `cross join`:

```sql
SELECT products.name AS product, colors.name AS color
FROM   products
CROSS JOIN colors;
```

If you have 20 products and 10 colors, that's 200 rows right there!

Here's a `natural join` example using two tables, MongoDB employees and MongoDB managers:

```sql
SELECT *
FROM   mongodb_employees
LEFT JOIN mongodb_managers
ON     mongodb_employees.id = mongodb_managers.id
WHERE  mongodb_managers.id IS NULL;
```

This natural join returns all rows from MongoDB employees where there is no matching row in managers based on the id column.

---

### 6. Filter and Aggregate Customer Reviews Data

A business has been collecting reviews on its products and wants to understand how the products have been received by the customers. 

Specifically, they would like to see a monthly average rating for each product during the past year. The business uses PostgreSQL for their database.

**Write a SQL query that filters and aggregates the data from the reviews table to display the month of review submission, product id, and average stars received for each product on a monthly basis.**

`reviews` **Example Input:**

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|--------------|------------|-------|
| 6171      | 123     | 2021-06-08  | 50001      | 4     |
| 7802      | 265     | 2021-06-10  | 69852      | 4     |
| 5293      | 362     | 2021-06-18  | 50001      | 3     |
| 6352      | 192     | 2021-07-26  | 69852      | 3     |
| 4517      | 981     | 2021-07-05  | 69852      | 2     |

**Example Output:**

| mth | product | avg_stars |
|-----|---------|----------:|
| 6   | 50001   |      3.50 |
| 6   | 69852   |      4.00 |
| 7   | 69852   |      2.50 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) AS month,
         product_id as product,
         ROUND(AVG(stars), 2) as avg_stars
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 7. What does it mean to normalize a database?

Normalization involves breaking up your tables into smaller, more specialized ones and using primary and foreign keys to define relationships between them. Not only does this make your database more flexible and scalable, it also makes it easier to maintain. Plus, normalization helps to keep your data accurate by reducing the chance of inconsistencies and errors.

The only downside is now is that your queries will involve more joins, which are slow AF and often a DB performance botteleneck.

---

### 8. Average Response Time Per Customer Request

In the technical support team at MongoDB, the support tickets are stored in a table. For each request, the time from when it's received to when it's addressed and closed may vary. 

You have been asked to determine the average response time, in hours, for each ticket priority level ("High", "Medium", "Low"). Breakdown this statistic by the priority of the requests.

Assume we have a table `requests` with the following structure:

`requests` **Example Input:**

| request_id | submit_time          | close_time           | priority |
|------------|----------------------|----------------------|----------|
| 4789       | 2026-08-08 00:00:00 | 2026-08-08 05:29:13 | High     |
| 6352       | 2026-08-07 11:04:28 | 2026-08-08 02:45:30 | Low      |
| 7813       | 2026-08-08 15:20:15 | 2026-08-08 18:31:22 | High     |
| 5296       | 2026-08-07 16:07:12 | 2026-08-08 00:46:30 | Medium   |
| 3459       | 2026-08-07 22:35:20 | 2026-08-08 01:04:50 | Low      |


**Answer:**

```sql
SELECT   priority, 
         AVG(EXTRACT(EPOCH FROM (close_time - submit_time)) / 3600) AS avg_response_time
FROM     requests
GROUP BY 1
```

---

### 9. Calculating Click-Through Rates for MongoDB Ads

You are a data analyst at MongoDB, a document database company providing the versatility needed to work with data in any structure. Marketing team has been running campaigns online and they want to understand how effective their campaigns are.

Specifically, they want to **find out the "Click Through Rate (CTR)" for each campaign they have run in last month.** 

The click-through rate is simply calculated by taking the number of users who clicked on the ad divided by the number of users who have seen the ad.

You are given two tables, `impressions` and `clicks`. 

- The `impressions` table contains information about when and which user saw the advertisement. 

- The `clicks` table contains information about when and which user clicked on the advertisement.

`impressions` **Example Input:**

| impression_id | user_id | impression_date     | campaign_id |
|---------------|---------|----------------------|-------------|
| 172           | 123     | 06/08/2022 00:00:00 | 3           |
| 182           | 234     | 06/10/2022 00:00:00 | 3           |
| 213           | 150     | 06/18/2022 00:00:00 | 5           |
| 109           | 110     | 06/18/2022 00:00:00 | 5           |
| 127           | 123     | 07/05/2022 00:00:00 | 3           |

`clicks` **Example Input:**

| click_id | user_id | click_date           | campaign_id |
|----------|---------|----------------------|-------------|
| 717      | 123     | 06/08/2022 00:00:00 | 3           |
| 722      | 265     | 06/18/2022 00:00:00 | 5           |
| 519      | 192     | 07/05/2022 00:00:00 | 3           |

**Answer:**

```sql
SELECT imp.campaign_id, 
       (clicks.count::decimal / imp.count::decimal) as click_through_rate
FROM 
   (SELECT campaign_id, COUNT(*) 
   FROM impressions
   WHERE DATE_PART('month', impression_date) = DATE_PART('month', CURRENT_DATE) - 1
   GROUP BY campaign_id) as imp
JOIN 
   (SELECT campaign_id, COUNT(*) 
   FROM clicks
   WHERE DATE_PART('month', click_date) = DATE_PART('month', CURRENT_DATE) - 1
   GROUP BY campaign_id) as clicks
ON imp.campaign_id = clicks.campaign_id;
```

---


### 10. Can you describe the concept of a database index and the various types of indexes?

An index in a database is a data structure that helps to quickly find and access specific records in a table.

For example, if you had a database of MongoDB customers, you could create a primary index on the customer_id column.

Having a primary index on the customer_id column can speed up performance in several ways. For example, if you want to retrieve a specific customer record based on their customer_id, the database can use the primary index to quickly locate and retrieve the desired record. The primary index acts like a map, allowing the database to quickly find the location of the desired record without having to search through the entire table.

Additionally, a primary index can also be used to enforce the uniqueness of the customer_id column, ensuring that no duplicate customer_id values are inserted into the table. This can help to prevent errors and maintain the integrity of the data in the table.

---

### 11. Average Sales By Product Per Month

As a Data Analyst at MongoDB, you'd want to oversee sales performance by month for multiple products. 

**Write a SQL query that calculates the average sales per month for each product.**

We are interested in getting both the total sales and the average value per transaction.

Consider the following table sales:

`sales` **Example Input:**

| sale_id | customer_id | date_of_sale        | product_id | amount |
|---------|-------------|----------------------|------------|-------:|
| 1011    | 125         | 06/02/2022 00:00:00 | 10001      |    300 |
| 1023    | 789         | 06/10/2022 00:00:00 | 20052      |    800 |
| 3014    | 215         | 06/29/2022 00:00:00 | 10001      |    500 |
| 4016    | 473         | 07/05/2022 00:00:00 | 20052      |    400 |
| 5013    | 313         | 07/22/2022 00:00:00 | 10001      |    600 |


**Example Output:**

| month | product_id | average_sale |
|-------|------------|-------------:|
| 6     | 10001      |          400 |
| 6     | 20052      |          800 |  
| 7     | 10001      |          600 |
| 7     | 20052      |          400 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM date_of_sale) as month,
         product_id,
         AVG(amount) as average_sale  
FROM     sales
GROUP BY 1, 2
ORDER BY 1, 2
```

---