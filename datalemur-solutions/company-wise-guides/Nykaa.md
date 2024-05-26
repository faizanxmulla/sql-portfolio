## 9 Nykaa SQL Interview Questions

### 1. Identify Whale Users for Nykaa

Nykaa is an online retail company that sells beauty and wellness products. 

The business considers a "Whale User" to be a user who makes purchases frequently (say more than 4 orders a month) and whose total transaction value is high (say, more than $1,000 a month). 

**Write a SQL query that identifies these Whale Users.**

`orders` **Example Input:**

| order_id | user_id | order_date | total_amount |
|----------|---------|------------|--------------|
| 2769     | 12      | 06/08/2022 | 220          |
| 3412     | 45      | 06/10/2022 | 500          |
| 9894     | 12      | 06/11/2022 | 255          |
| 3463     | 33      | 06/15/2022 | 450          |
| 1775     | 45      | 06/24/2022 | 1200         |
| 3932     | 12      | 06/25/2022 | 190          |
| 2113     | 45      | 06/30/2022 | 400          |

`users` **Example Input:**

| user_id | user_name |
|---------|-----------|
| 12      | Alice     |
| 33      | Bob       |
| 45      | Charlie   |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM order_date) as month, 
	     user_id, 
         COUNT(order_id) as total_order_count, 
         SUM(total_amount) as total_transaction_value
FROM     orders JOIN users USING(user_id)
GROUP BY 1, 2
HAVING   COUNT(order_id) > 4 AND SUM(total_amount) > 1000
```

---

### 2. Calculate Monthly Average Ratings

Nykaa is a multi-brand beauty retailer selling cosmetic and wellness products. As a data analyst, you are tasked with analyzing product reviews. You are to provide a breakdown of the **average ratings a product receives each month.**

`reviews` **Example Input:**

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|-------------|------------|-------|
| 1234      | 78      | 2022-01-15  | 001        | 5     |
| 2345      | 89      | 2022-01-20  | 002        | 4     |
| 3456      | 90      | 2022-01-30  | 001        | 3     |
| 4567      | 91      | 2022-02-01  | 001        | 2     |
| 5678      | 92      | 2022-02-05  | 002        | 5     |
| 6789      | 93      | 2022-02-25  | 001        | 4     |
| 7890      | 94      | 2022-02-28  | 002        | 3     |
| 8901      | 95      | 2022-03-01  | 001        | 4     |
| 9012      | 96      | 2022-03-15  | 002        | 5     |
| 0123      | 97      | 2022-03-30  | 001        | 2     |

The output should give the product id, the month, and the average rating for that month.

**Example Output:**

| product_id | month | avg_rating |
|------------|-------|------------|
| 001        | 1     | 4.00       |
| 002        | 1     | 4.00       |
| 001        | 2     | 3.00       |
| 002        | 2     | 4.00       |
| 001        | 3     | 3.00       |
| 002        | 3     | 5.00       |

**Answer:**

```sql
SELECT   product_id, 
         EXTRACT(MONTH FROM submit_date) AS month, 
         AVG(stars) as avg_rating
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 3. DBMS transactions are expected to follow the ACID properties. What are they, and what does each property mean?

**Answer**:

ACID refers to the four key properties that are essential to the reliable and correct execution of database transactions. These properties are:

- **Atomicity**: ensures that a transaction is treated as a single operation, and either all of the changes are made or none of them are! Basically, the database version of a "-FULL SEND-"

- **Consistency**: ensures that the data is in a consistent state before and after a transaction is completed. For example, if wiring money to a friendly Nigerian prince whose fallen on hard times, consistency ensures that the total value of funds lost in my account is the same amount that's gained in the prince's account!

- **Isolation**: ensures that the intermediate state of a transaction is invisible to other transactions. Back to the wiring-the-prince-some-money example, isolation ensures that another transaction sees the transferred funds in my account OR the princes, but not in both accounts at the same time

- **Durability**: ensures that once a transaction has been completed successfully, the changes made by the transaction are permanent and cannot be undone, even in the event of a system failure. Basically, no taksies backsies (even if your system has a meltdown!).

---

### 4. Product Popularity

Nykaa, a leading beauty and wellness e-commerce platform, is tempting to analyze how well their diversified range of products are performing. 

To do this, you need to design a database schema that models users, products and purchases. 

Nykaa is mainly interested in finding out the top 5 popular products, determined by the amount of unique users purchasing each product. 

Design the database tables considering these needs, create sample data, and **write a SQL query to find the top 5 products accompanied by the number of unique users who purchased them.**

`users` **Example Input:**

| user_id | user_name          | email                  | join_date |
|---------|---------------------|------------------------|-----------|
| 1       | John Doe            | john_doe@example.com   | 2021-08-01|
| 2       | Jane Doe            | jane_doe@example.com   | 2021-09-01|
| 3       | Sam Smith           | sam_smith@example.com  | 2022-01-01|

`products` **Example Input:**

| product_id | product_name | price |
|------------|--------------|-------|
| 100        | Lipstick A   | 500   |
| 200        | Eye Pencil B | 300   |
| 300        | Foundation C | 1000  |

`purchases` **Example Input:**

| purchase_id | user_id | product_id | purchase_date |
|-------------|---------|------------|---------------|
| 1           | 1       | 100        | 2022-01-15    |
| 2           | 2       | 200        | 2022-02-18    |
| 3           | 1       | 200        | 2022-03-15    |
| 4           | 3       | 300        | 2022-04-18    |
| 5           | 2       | 300        | 2022-05-15**Answer:**


**Answer**:

```sql
SELECT   p.product_id, 
         p.product_name, 
         COUNT(DISTINCT pu.user_id) as unique_user_purchases
FROM     products p JOIN purchases pu USING(product_id)
GROUP BY 1, 2
ORDER BY 3 DESC 
LIMIT    5;
```

---

### 5. Can you describe the concept of a database index and the various types of indexes?

An index in a database is a data structure that helps to quickly find and access specific records in a table.

For example, if you had a database of Nykaa customers, you could create a primary index on the `customer_id` column.

Having a primary index on the `customer_id` column can speed up performance in several ways. For example, if you want to retrieve a specific customer record based on their `customer_id`, the database can use the primary index to quickly locate and retrieve the desired record. The primary index acts like a map, allowing the database to quickly find the location of the desired record without having to search through the entire table.

Additionally, a primary index can also be used to enforce the uniqueness of the `customer_id` column, ensuring that no duplicate `customer_id` values are inserted into the table. This can help to prevent errors and maintain the integrity of the data in the table.


---

### 5. Nykaa Customer Behavior Analysis

You are a data analyst at Nykaa, an online cosmetic and wellness retailer. Management wants to know the behavior of the customers who have made repeated purchases in the last year but have not made any purchase in the last 3 months. 

Additionally, they are interested in customers who have their total purchase amount greater than $1000.

Create a SQL query to extract the required details:

- The customer has made purchases in the last year

- The customer has not made any purchase in the last 3 months

- The total purchase amount of the customer is greater than '1000'

The `orders` table is given below:

`orders` **Example Input**:

| order_id | customer_id | order_date | product_id | amount |
|----------|-------------|------------|------------|--------|
| 101      | 501         | 08/13/2021 | 60001      | 200    |
| 102      | 552         | 03/19/2022 | 65052      | 150    |
| 103      | 712         | 07/09/2021 | 60001      | 250    |
| 104      | 501         | 12/11/2021 | 65052      | 300    |
| 105      | 552         | 01/05/2022 | 60001      | 400    |
| 106      | 501         | 07/26/2021 | 60001      | 350    |

**Answer:**

```sql
SELECT   customer_id, SUM(amount) AS total_amount
FROM     orders
WHERE    order_date BETWEEN NOW() - INTERVAL '1 year' AND NOW() - INTERVAL '3 months'
GROUP BY 1
HAVING   SUM(amount) > 1000;
```

---

### 7. What is the process for finding records in one table that do not exist in another?

To find records in one table that aren't in another, you can use a `LEFT JOIN` and check for `NULL` values in the right-side table.

Here's an example using two tables, `Nykaa_employees` and `Nykaa_managers`:

```sql
SELECT *
FROM   nykaa_employees e LEFT JOIN nykaa_managers m USING(id)
WHERE  m.id IS NULL;
```

This query returns all rows from `Nykaa_employees` where there is no matching row in `managers` based on the `id` column.

You can also use the `EXCEPT` operator in PostgreSQL and Microsoft SQL Server to return the records that are in the first table but not in the second. Here is an example:

```sql
SELECT * 
FROM   nykaa_employees
EXCEPT
SELECT * 
FROM   nykaa_managers
```

This will return all rows from `employees` that are not in `managers`. The `EXCEPT` operator works by returning the rows that are returned by the first query, but not by the second.

Note that `EXCEPT` isn't supported by all DBMS systems, like in MySQL and Oracle (but have no fear, since you can use the `MINUS` operator to achieve a similar result).


---

### 8. Nykaa's Click-Through Rate Analysis

Nykaa is an Indian retail seller of beauty, wellness, and fashion products. As a data analyst for Nykaa, you are tasked to analyze the click-through rates (CTR) of their digital ads to help improve their marketing strategy.

Here's your task: **Calculate the click-through rate for each ad.** 

Click-through rate (CTR) is calculated as the number of users who clicked on the ad divided by the number of total ad impressions.


`ad_impressions` **Example Input**:

| ad_id | impression_date | views |
|-------|-----------------|-------|
| 101   | 02/02/2022      | 5000  |
| 102   | 02/05/2022      | 6500  |
| 103   | 02/10/2022      | 8000  |
| 104   | 02/15/2022      | 7500  |
| 105   | 02/20/2022      | 7000  |

`ad_clicks` **Example Input**:

| click_id | ad_id | click_date | user_id |
|----------|-------|------------|---------|
| 111      | 101   | 02/03/2022 | 301     |
| 112      | 101   | 02/03/2022 | 302     |
| 113      | 102   | 02/06/2022 | 303     |
| 114      | 102   | 02/06/2022 | 304     |
| 115      | 103   | 02/11/2022 | 305     |

The ad IDs in both the tables correspond to the same ad.

**Answer:**


```sql
SELECT   i.ad_id,
         i.views AS total_views,
         COUNT(c.click_id) AS total_clicks, 
         100.0 * (COUNT(c.click_id) / i.views) AS ctr
FROM     ad_impressions i LEFT JOIN ad_clicks c USING(ad_id)
GROUP BY 1, 2
```

---

### 9. Analyze customers' purchase and review data

Assume a company named Nykaa runs an online store that sells beauty products. They have two tables, one is `Customers` and another is `Purchases`. 

In the `Customers` table, each row represents a unique customer with fields: `customer_id`, `first_name`, and `last_name`. 

In the `Purchases` table, each row describes a product purchased by a customer, with fields: `purchase_id`, `customer_id`, `product_id`, `purchase_date`, and `review_stars`.

The task is to write a SQL query that brings together these two tables to **show the first and last names of customers along with the IDs and review_stars of products they purchased.**

`customers` **Example Input:**

| customer_id | first_name | last_name |
|-------------|------------|-----------|
| 101         | Emma       | Johnson   |
| 102         | Olivia     | Williams  |
| 103         | Ava        | Jones     |


`purchases` **Example Input:**

| purchase_id | customer_id | product_id | purchase_date | review_stars |
|-------------|-------------|------------|---------------|--------------|
| 1001        | 101         | 2001       | 07/01/2022    | 5            |
| 1002        | 102         | 2002       | 07/02/2022    | 4            |
| 1003        | 101         | 2003       | 07/03/2022    | 3            |

**Example Output:**

| first_name | last_name | product_id | review_stars |
|------------|-----------|------------|--------------|
| Emma       | Johnson   | 2001       | 5            |
| Olivia     | Williams  | 2002       | 4            |
| Emma       | Johnson   | 2003       | 3            |

**Answer:**

```sql
SELECT c.first_name, c.last_name, p.product_id, p.review_stars
FROM   customers c JOIN Purchases p USING(customer_id)
```

---