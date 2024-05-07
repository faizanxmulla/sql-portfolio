## 10 Snowflake SQL Interview Questions


### 1. Identify VIP Users in Snowflake

Assume that Snowflake, a cloud-based data-warehousing company, wants to identify its power users. A power user is defined as any user who runs at least 500 query requests per month. 

The aim is to identify these power users so that special care can be taken to ensure their needs are being met and their experience with Snowflake is as smooth as possible.

**Write a SQL query to get the usernames of all power users and the number of their monthly queries for the last 12 months.**

`user_queries` **Example Input:**

| query_id | user_id | username | query_time |
|----------|---------|-----------|------------|
| 101      | 1       | john_doe  | 2022-01-15 10:30:00 |
| 102      | 2       | jane_doe  | 2022-02-18 09:20:00 |
| 103      | 1       | john_doe  | 2022-01-20 08:15:00 |
| 104      | 3       | bill_bixby| 2022-01-25 14:40:00 |
| 105      | 1       | john_doe  | 2022-02-10 16:50:00 |
| ...      | ...     | ...       | ...                 |

**Answer:**

```sql
SELECT   username, 
         TO_CHAR(query_time, 'YYYY-MM') as month_year, 
         COUNT(*) as monthly_queries 
FROM     user_queries 
WHERE    query_time >= (CURRENT_DATE - INTERVAL '1 year') 
GROUP BY 1, 2
HAVING   COUNT(*) >= 500 
ORDER BY 1, 2
```

---

### 2. Calculating Monthly Average Product Ratings

You are an analyst at an e-commerce company. The company wants to track the average monthly rating of each product to assess performance trends. 

**Write a SQL query that calculates the average rating (stars) for each product on a monthly basis, ordered by the month and then product id.**

We will use the `reviews` table that consists of the following columns:

- `review_id` (integer, primary key)

- `user_id` (integer)
- `submit_date` (date)
- `product_id` (integer)
- `stars` (integer, range between 1 and 5)

`reviews` **Example Input:**

| review_id | user_id | submit_date         | product_id | stars |
|-----------|---------|---------------------|------------|-------|
| 6171      | 123     | 06/08/2022 00:00:00 | 50001      | 4     |
| 7802      | 265     | 06/10/2022 00:00:00 | 69852      | 4     |
| 5293      | 362     | 06/18/2022 00:00:00 | 50001      | 3     |
| 6352      | 192     | 07/26/2022 00:00:00 | 69852      | 3     |
| 4517      | 981     | 07/05/2022 00:00:00 | 69852      | 2     |

**Answer:**

```sql
SELECT   EXTRACT(month from submit_date) as month, 
		 product_id, 
         ROUND(AVG(stars), 2) as avg_stars
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2

-- OR --

SELECT   EXTRACT(month from submit_date) as month, 
		 product_id, 
         AVG(stars) OVER (PARTITION BY product_id, EXTRACT(MONTH FROM submit_date)) AS avg_stars
FROM     reviews
ORDER BY 1, 2
```
---

### 3. What's a cross-join, and why are they used?

A cross-join, also known as a cartesian join, is a type of JOIN operation in SQL that creates a new table by combining each row from the first table with every row from the second table. This results in a table with a row for every possible combination of rows from the two input tables.

An example of when this might be useful is if you wanted to first make a dataset containing all possible pairs of customers and products data, in order to later build a Machine Learning model to predict the probability of a customer purchasing a particular product.

```sql
SELECT customers.id AS customer_id, snowflake_products.id AS product_id
FROM   customers
CROSS JOIN snowflake_products;
```

However, it is important to note that cross-joins can create very large tables, especially if the input tables have a large number of rows. For example, if you had 10,000 customers and 5,000 different product SKUs, the resulting cross-join would have 50 million rows.

---

### 4. Product Usage Analysis

Snowflake Inc is a cloud-based data warehousing platform that enables data storage, processing, and analytic solutions compatible with various cloud platforms. As a Data Analyst at Snowflake, your task is to analyze product usage over some time. Each product use is logged in a `product_usage` table.

`product_usage` **Example Input:**

| log_id | user_id | product_id | usage_date | usage_time |
|--------|---------|------------|------------|------------|
| 1021   | 203     | 3001       | 06/01/2022 | 05:30:00   |
| 1078   | 254     | 5001       | 07/01/2022 | 18:45:00   |
| 1033   | 420     | 5001       | 08/01/2022 | 10:10:00   |
| 1050   | 203     | 3001       | 09/01/2022 | 14:55:00   |
| 1105   | 642     | 7001       | 10/01/2022 | 19:30:00   |

The table `product_usage` contains information on which user (`user_id`) used what product (`product_id`) at what date (`usage_date`) and time (`usage_time`).

**Write a SQL query that gives an output consisting of each product, the number of times it has been used, and the distinct number of users who used it.**

**Example Output:**

| product_id | usage_count | distinct_users |
|------------|--------------|----------------|
| 3001       | 2           | 1              |
| 5001       | 2           | 2              |
| 7001       | 1           | 1              |

**Answer:**

```sql
SELECT   product_id,
         COUNT(*) AS usage_count,
         COUNT(DISTINCT user_id) AS distinct_users
FROM     product_usage
GROUP BY 1
```

---

### 5. What are the various types of joins used in SQL?

In SQL, a join is used to combine rows from different tables based on a shared key or set of keys, resulting in a single merged table of data.

There are four distinct types of JOINs: `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN`.

- **(INNER) JOIN**: Retrieves records that have matching values in both tables involved in the join.

```sql
SELECT *
FROM Table_A
JOIN Table_B;

SELECT *
FROM Table_A
INNER JOIN Table_B;
```

- **LEFT (OUTER) JOIN**: Retrieves all the records/rows from the left and the matched records/rows from the right table.

```sql
SELECT *
FROM Table_A A
LEFT JOIN Table_B B ON A.col = B.col;
```

- **RIGHT (OUTER) JOIN**: Retrieves all the records/rows from the right and the matched records/rows from the left table.

```sql  
SELECT *
FROM Table_A A
RIGHT JOIN Table_B B ON A.col = B.col;
```

- **FULL (OUTER) JOIN**: Retrieves all the records where there is a match in either the left or right table.

```sql
SELECT *
FROM Table_A A
FULL JOIN Table_B B ON A.col = B.col;
```

---

### 6. Filter Customers Who Made Purchases Last Month

Company XYZ has a customer record database and you are required to filter out the customers who made purchases last month. 

The purchases need to be above $500 and the customer needs to be from the United States. You also have to filter customers who have not logged into their accounts in the past year.

Attached below is a sample set of data that comes from the `purchases` and `customers` tables.

`purchases` **Example Input:**

| purchase_id | customer_id | purchase_date | purchase_amount |
|-------------|-------------|----------------|-----------------|
| 6213        | 154         | 06/15/2022     | 750             |
| 8505        | 896         | 05/08/2022     | 300             |
| 3846        | 697         | 07/25/2022     | 600             |
| 2910        | 540         | 08/12/2022     | 450             |

`customers` **Example Input:**

| customer_id | first_name | last_name | country | last_login_date |
|-------------|------------|------------|---------|-----------------|
| 154         | John       | Smith     | USA     | 07/15/2022      |
| 896         | Maria      | Johnson   | USA     | 08/10/2021      |
| 697         | Sarah      | Davis     | CAN     | 06/30/2022      |
| 540         | David      | Brown     | USA     | 08/12/2019      |

**Answer:**

```sql
-- my approach

SELECT *
FROM   customers c JOIN purchases p USING(customer_id)
WHERE  purchase_amount > 500 and 
	   country='USA' and
       purchase_date <= CURRENT_DATE - INTERVAL '1 month' and 
       last_login_date > CURRENT_DATE - INTERVAL '1 year'

-- or -- 

SELECT c.customer_id, c.first_name, c.last_name
FROM   customers c JOIN purchases p USING(customer_id)
WHERE  p.purchase_date >= DATEADD(month, -1, CURRENT_DATE) and
       p.purchase_amount > 500 and 
       c.country = 'USA' and 
       c.last_login_date >= DATEADD(year, -1, CURRENT_DATE)
```



---

### 7. What does UNION do?

The `UNION` operator merges the output of two or more `SELECT` statements into a single result set. The two `SELECT` statements within the `UNION` must have the same number of columns and the data types of the columns are all compatible.

For example, if you were a Data Analyst on the marketing analytics team at Snowflake, this `SELECT` statement would return a combined result set of both Snowflake's Google and Facebook ads that have more than 300 impressions:

```sql
SELECT ad_id, ad_name, impressions, clicks
FROM   snowflake_google_ads
WHERE  impressions > 300;

UNION

SELECT ad_id, ad_name, impressions, clicks
FROM   snowflake_facebook_ads
WHERE  impressions > 300
```

---

### 8. Calculate Click-Through Rates for Ads

You are given two tables, `Ads` and `Clicks`. The `Ads` table has information about all the digital ads displayed to users. 

It includes a unique identifier for each ad (`ad_id`), the date the ad was shown (`ad_date`), and the unique identifier of the user (`user_id`) to whom the ad was shown. The `Clicks` table contains logs of whenever a user clicked on an ad. 

It also includes a unique identifier for each click (`click_id`), the date of the click (`click_date`), and the user's identifier who clicked the ad.

The task is to **write a SQL query to calculate the click-through rate (CTR) for all ads shown in the month of October 2022**. 

The CTR is calculated as the number of clicks that an ad gets divided by the number of times the ad was shown, expressed as a percentage.

`ads` **Example Input:**

| ad_id | ad_date   | user_id |
|-------|------------|---------|
| 1001  | 10/02/2022 | 1234    |
| 1002  | 10/08/2022 | 5678    |
| 1003  | 10/15/2022 | 4321    |
| 1004  | 10/25/2022 | 8765    |
| 1005  | 11/01/2022 | 1278    |

`clicks` **Example Input:**

| click_id | click_date | ad_id | user_id |
|----------|------------|-------|---------|
| 2001     | 10/03/2022 | 1001  | 1234    |
| 2002     | 10/09/2022 | 1002  | 5678    |
| 2003     | 10/16/2022 | 1003  | 4321    |
| 2004     | 11/02/2022 | 1005  | 1278    |

**Answer:**

```sql
SELECT   a.ad_id,
         COUNT(c.click_id) AS number_of_clicks, 
         COUNT(a.ad_id) AS number_of_ad_displays, 
         100.0 * (COUNT(c.click_id) / COUNT(a.ad_id)) AS CTR
FROM     Ads a LEFT JOIN Clicks c ON a.ad_id = c.ad_id AND a.user_id = c.user_id 
WHERE    EXTRACT(MONTH FROM a.ad_date) = 10 AND EXTRACT(YEAR FROM a.ad_date) = 2022
GROUP BY 1
```

---