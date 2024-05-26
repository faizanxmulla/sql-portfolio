## 9 Databricks SQL Interview Questions (Updated 2024)


### 1. Identifying Power Users for Databricks

As a Databricks data analyst, one of the most important tasks is identifying our power users. These are users who frequently use Databricks' tools and services, indicating a high level of engagement. These power users often bring in substantial revenue for the company, making them crucial to identify. 

For this problem, assume you have been given access to two tables: 'users', containing basic user information, and 'transactions', tracking all their actions in past month. 

All users who made transactions with a total amount of at least 50000 in past month are considered as power user.

**Write a SQL query to find out the information of power users from the 'users' table. Display the user's id, name, and the total amount they spent in past month.**

The structure of 'users' and 'transactions' table is given as below:

`users` Example Input:

| user_id | user_name     | zip_code | email                 |
|---------|---------------|----------|------------------------|
| 1001    | John Doe      | 37027    | johndoe@example.com    |
| 1002    | Mary Johnson  | 37201    | maryj@example.com      |
| 1003    | James Smith   | 37211    | jamessmith@example.com |
| 1004    | Patricia Brown| 37076    | pbrown@example.com     |
| 1005    | Robert Davis  | 37013    | rdavis@example.com     |

`transactions` Example Input:

| transaction_id | user_id | amount | date       |
|----------------|---------|--------|------------|
| 6001           | 1001    | 20000  | 2022-07-01 |
| 6002           | 1002    | 10000  | 2022-07-02 |
| 6003           | 1001    | 35000  | 2022-07-05 |
| 6004           | 1002    | 30000  | 2022-07-09 |
| 6005           | 1003    | 25000  | 2022-07-10 |

#### Solution:

```sql
SELECT   u.user_id,
         u.user_name,
         SUM(t.amount) as total_spent_last_month
FROM     users u JOIN transactions t USING(user_id)
WHERE    t.date BETWEEN '2022-07-01' AND '2022-07-31'
GROUP BY 1, 2
HAVING   SUM(t.amount) >= 50000
ORDER BY 3 DESC;


-- can be performed both in MySQL as well as in PostgreSQL.
```

---

### 2. Calculate the Monthly Average Rating for Each Product

For a company like Databricks that might offer multiple products, it's often important to track customer feedback over time. In this question, you're given a 'reviews' table that contains various product reviews submitted by users, with each review having a timestamp (in the form of a submitted date) and a star rating. 

Your task is to : 

**Write an SQL query that calculates the average star rating for each product on a monthly basis.** 

Make sure your query returns the month, product_id, and the average stars for each product in that month.

`reviews` Example Input:

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|-------------|------------|-------|
| 6171      | 123     | 2022-06-08  | 50001      | 4     |
| 7802      | 265     | 2022-06-10  | 69852      | 4     |
| 5293      | 362     | 2022-06-18  | 50001      | 3     |
| 6352      | 192     | 2022-07-26  | 69852      | 3     |
| 4517      | 981     | 2022-07-05  | 69852      | 2     |

Expected Output:

| month | product_id | avg_stars |
|-------|------------|-----------|
| 6     | 50001      | 3.50      |
| 6     | 69852      | 4.00      |
| 7     | 69852      | 2.50      |

#### Solution:

```sql
SELECT   EXTRACT(MONTH FROM submit_date) as month, product_id, AVG(stars) as avg_stars
FROM     reviews
GROUP BY 1, 2
```

---

### 3. How do you identify records in one table that aren't in another?

To discover records in one table that are not present in another, you can utilize a LEFT JOIN and filter out any NULL values in the right-side table.

For example, say you had a table of Databricks customers and a 2nd table of all purchases made with Databricks. To find all customers who did not make a purchase, you'd use the following LEFT JOIN

```sql
SELECT *
FROM   customers c LEFT JOIN purchases p ON c.id = p.customer_id
WHERE  p.id IS NULL;
```

This query fetches all rows from the customers table, along with any rows that match in the purchases table. 

If there is no matching row in the purchases table, NULL values will be returned for all of the right table's columns. 

The WHERE clause then filters out any rows where the purchases.id column is NULL, leaving only customers who have not made a purchase.

---

### 4. Database Design for Databricks Machine Learning Jobs  

Databricks is a leading data analytics platform that also offers robust machine learning capabilities. Your role will involve designing a database for tracking ML jobs running on the platform.

There would be two main entities - Jobs and Users. A single user can create multiple jobs, so there is a one-to-many relationship between Users and Jobs.

The following are the suggested attributes (columns) for each entity:

- Users: user_id, account_created_date, last_login
- Jobs: job_id, user_id, launched_date, description, status

The status attribute in Jobs table could have values like 'In Progress', 'Completed', or 'Failed'.

Create a solution to track the last 3 jobs each user launched and their status. The output should be sorted by the launched_date in a descending order.

`users` Example Input:

| user_id | account_created_date | last_login           |
|---------|----------------------|----------------------|
| 1       | 06/01/2022 00:00:00  | 08/01/2022 00:00:00 |
| 2       | 04/15/2022 00:00:00  | 08/01/2022 00:00:00 |
| 3       | 05/20/2022 00:00:00  | 08/01/2022 00:00:00 |
| 4       | 03/30/2022 00:00:00  | 08/01/2022 00:00:00 |
| 5       | 02/15/2022 00:00:00  | 08/01/2022 00:00:00 |

`jobs` Example Input:

| job_id | user_id | launched_date        | description | status       |
|--------|---------|----------------------|-------------|--------------|
| 1001   | 1       | 07/30/2022 00:00:00  | "ML Job A"  | "In Progress"|
| 1002   | 2       | 07/29/2022 00:00:00  | "ML Job B"  | "Completed"  |
| 1003   | 2       | 07/28/2022 00:00:00  | "ML Job C"  | "Failed"     |
| 1004   | 3       | 07/27/2022 00:00:00  | "ML Job D"  | "Completed"  |
| 1005   | 2       | 07/26/2022 00:00:00  | "ML Job E"  | "In Progress"|
| 1006   | 5       | 07/25/2022 00:00:00  | "ML Job F"  | "Completed"  |
| 1007   | 4       | 07/24/2022 00:00:00  | "ML Job G"  | "Failed"     |
| 1008   | 1       | 07/23/2022 00:00:00  | "ML Job H"  | "Completed"  |

#### Solution:

```sql
WITH ranked_jobs as (
	SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY launched_date desc)
	FROM   jobs
)
SELECT *
FROM   users u LEFT JOIN ranked_jobs rj USING(user_id)
WHERE  rank <= 3
```

---

### 5. Can you explain what MINUS / EXCEPT SQL commands do?  

The MINUS/EXCEPT operator is used to remove to return all rows from the first SELECT statement that are not returned by the second SELECT statement.

Note that EXCEPT is available in PostgreSQL and SQL Server, while MINUS is available in MySQL and Oracle (but don't stress about knowing which DBMS supports what exact commands since the interviewers at Databricks should be lenient!).

Here's a PostgreSQL example of using EXCEPT to find all of Databricks's Facebook video ads with more than 10k views that aren't also being run on YouTube:

```sql
SELECT ad_creative_id
FROM   databricks_facebook_ads
WHERE  views > 10000 AND type=video

EXCEPT

SELECT ad_creative_id  
FROM   databricks_youtube_ads
```

If you want to retain duplicates, you can use the EXCEPT ALL operator instead of EXCEPT. The EXCEPT ALL operator will return all rows, including duplicates.

---

### 6. Filter Customer Records Based on Multiple Conditions

Given a database of customer records, your task is to filter the records based on certain conditions. You will need to list customers who signed up after 2018-01-01, are located in New York, and have spent over 5000 units of currency on products in the Electronics department.

`customer` Example Input:

| customer_id | signup_date | location   | total_spend |
|-------------|-------------|------------|-------------|
| 1           | 2021-08-13  | New York   | 10000       |
| 2           | 2019-03-26  | San Francisco | 4500     |
| 3           | 2020-12-23  | New York   | 6000        |
| 4           | 2017-01-14  | New York   | 7000        |
| 5           | 2019-11-20  | Los Angeles| 3000        |

`purchase` Example Input:

| purchase_id | customer_id | department  | amount |
|-------------|-------------|-------------|--------|
| 101         | 1           | Electronics | 6000   |
| 102         | 2           | Home        | 3000   |
| 103         | 3           | Electronics | 5000   |
| 104         | 4           | Electronics | 6000   |
| 105         | 5           | Fashion     | 2000   |

Example Output:

| customer_id | signup_date | location | total_spend |
|-------------|-------------|----------|-------------|
| 1           | 2021-08-13  | New York | 10000       |
| 3           | 2020-12-23  | New York | 6000        |

#### Solution:

```sql
SELECT customer_id, signup_date, location, total_spend
FROM   customer c JOIN purchase p USING(customer_id)
WHERE  signup_date > '2018-01-01' AND 
		(location='New York' AND
         amount > 5000 AND
         department='Electronics')
```

---

### 7. What's a database view, and what's it used for?

A database view is a virtual table that is created based on the results of a SELECT statement, and provides you a customized, read-only version of your data that you can query just like a regular table.

Views in SQL can help you enforce data security requirements by hiding sensitive data from certain users, and can improve performance for some queries by pre-computing the results for an intermediate step and storing them in a view (which can be faster than executing the intermediate query each time). However, their read-only nature means that on any underlying update, the view has to be re-computed.

---

### 8. Calculate the Product Page Click-through to Adding to Cart Conversion Rate

As Databricks, we are very interested in understanding our product engagement. We have a table called "page_views" which represents product page views by customers, and another table "cart_adds" that represents every time a user adds a product into their shopping cart.  

The "page_views" table has the following schema:


- view_id (integer): unique identifier of the page view

- user_id (integer): unique identifier of the user

- view_date (date): the date when the page view occurred  

- product_id (integer): unique identifier of the viewed product

And the "cart_adds" table has the similar schema:


- add_id (integer): unique identifier of the cart addition

- user_id (integer): unique identifier of the user

- add_date (date): the date when the product was added to the cart

- product_id (integer): unique identifier of the added product

We want to know the click-through conversion rate from viewing a product to adding that product to the cart. 

**Create a SQL query that calculates the percentage of product page views which resulted in the same product being added to the cart, per product_id.**

`page_views` Example Input:  

| view_id | user_id | view_date | product_id |
|---------|---------|------------|------------|
| 1001    | 500     | 10/01/2022| 101        |
| 1002    | 501     | 10/02/2022| 102        |
| 1003    | 502     | 10/03/2022| 101        |
| 1004    | 500     | 10/04/2022| 102        |
| 1005    | 501     | 10/05/2022| 101        |

`cart_adds` Example Input:

| add_id | user_id | add_date  | product_id |
|--------|---------|------------|------------|
| 2001   | 500     | 10/02/2022| 101        |
| 2002   | 502     | 10/04/2022| 101        |
| 2003   | 501     | 10/05/2022| 101        |  
| 2004   | 500     | 10/03/2022| 102        |
| 2005   | 502     | 10/05/2022| 101        |

#### Solution:

```sql
SELECT   pv.product_id,
         COALESCE(100.0 * COUNT(ca.add_id) / COUNT(pv.view_id), 0) as conversion_rate
FROM     page_views as pv LEFT JOIN cart_adds as ca ON pv.user_id = ca.user_id
                                                    AND pv.product_id = ca.product_id 
                                                    AND pv.view_date <= ca.add_date
GROUP BY 1
```

---  

### 9. Filtering Client Data From Databricks

As a data professional at Databricks, your task is to filter through the client database to find records specific to client names that start with a given pattern. In this case, we would like you to retrieve all records of clients from the database whose names start with 'Data'.

Below is a sample table named clients hosting details such as client_id, client_name, join_date and client_type.

`clients` Example Input:

| client_id | client_name         | join_date | client_type |
|-----------|----------------------|-----------|-------------|
| 1         | Databricks Inc       | 2019-04-01| Enterprise  |
| 2         | Datamind Corp        | 2019-09-15| Start-up    |
| 3         | Infinity Tech        | 2020-02-11| SME         |
| 4         | Dataspace            | 2018-06-04| Enterprise  |
| 5         | Brainspark Solutions | 2020-09-19| Start-up    |

**Write a SQL command to pull records of clients whose name begins with 'Data'.**


#### Solution:

```sql
SELECT *
FROM   clients
WHERE  client_name LIKE 'Data%';
```

---