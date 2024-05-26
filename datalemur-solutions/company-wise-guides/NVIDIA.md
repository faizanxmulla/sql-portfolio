## 9 NVIDIA SQL Interview Questions

### 1. Average Ratings of NVIDIA Products

NVIDIA is interested in understanding the average ratings their products receive over time to better understand customer satisfaction. 

**Write a SQL query that calculates the monthly average reviews of NVIDIA products.**

Assume we have a reviews table with the following columns.

`reviews` **Example Input:**

| review_id | user_id | submit_date         | product_id | stars |
|-----------|---------|----------------------|------------|-------|
| 6171      | 123     | 06/08/2022 00:00:00 | 50001      | 4     |
| 7802      | 265     | 06/10/2022 00:00:00 | 69852      | 4     |
| 5293      | 362     | 06/18/2022 00:00:00 | 50001      | 3     |
| 6352      | 192     | 07/26/2022 00:00:00 | 69852      | 3     |
| 4517      | 981     | 07/05/2022 00:00:00 | 69852      | 2     |

**Example Output:**

| mth | product | avg_stars |
|-----|---------|----------:|
| 6   | 50001   |      3.50 |
| 6   | 69852   |      4.00 |
| 7   | 69852   |      2.50 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) AS mth,
         product_id AS product,
         AVG(stars) AS avg_stars
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 2. Find Customers Interested in AI

As an employee at NVIDIA, you've been given access to the customer records database. The Sensors team is interested in understanding which customers are interested in Artificial Intelligence (AI). The relevant fields are:

- `customer_id` - A unique identifier for the customer

- `name` - The name of the customer

- `email` - The email address of the customer

- `interests` - A list of customer's interests (e.g. 'Gaming', 'AI', 'Autonomous Machines')

**Write a SQL query to find customers who have shown an interest in AI**.

`customers` **Example Input:**

| customer_id | name           | email               | interests                     |
|-------------|-----------------|----------------------|-------------------------------|
| 1234        | John Smith     | johnsmith@email.com | Gaming, AI, Data Center       |
| 5678        | Mary Johnson   | maryj@email.com     | Gaming, Autonomous Machines   |
| 9123        | James Williams | jamesw@email.com    | AI, Autonomous Machines       |
| 4567        | Patricia Brown | patriciab@email.com | Data Center, AI               |

**Example Output:**

| customer_id | name           | email               |
|-------------|-----------------|----------------------|
| 1234        | John Smith     | johnsmith@email.com |
| 9123        | James Williams | jamesw@email.com    |
| 4567        | Patricia Brown | patriciab@email.com |

**Answer:**

```sql
SELECT customer_id, name, email
FROM   customers
WHERE  interests LIKE '%AI%';
```

---

### 3. What's the difference between a left and right join?

A join in SQL allows you to retrieve data from multiple tables and combine it into a single set of results.

To demonstrate the difference between left vs. right join, imagine you had two database tables, an advertising campaigns table which had information on Google Ads keywords and how much was bid for each keyword, and a sales table, which has data on how many products were sold and which Google Ads keyword drove that sale.

**LEFT JOIN:** A LEFT JOIN retrieves all rows from the left table (in this case, the Advertising_Campaigns table) and any matching rows from the right table (the Sales table). If there is no match in the right table, NULL values will be returned for the right table's columns.

**RIGHT JOIN:** A RIGHT JOIN retrieves all rows from the right table (in this case, the Sales table) and any matching rows from the left table (the Advertising_Campaigns table). If there is no match in the left table, NULL values will be returned for the left table's columns.


---

### 4. Average GPU Temperatures per Model

As an SQL analyst at NVIDIA, you are given task to monitor the performance of various GPU models. 

**Write a SQL query to find the average running temperature for each GPU model in the database.**


`gpu_temps` **Example Input:**

| record_id | timestamp           | model_id | temperature |
|-----------|----------------------|----------|------------:|
| 1         | 06/08/2022 00:00:00 | 1001     |          60 |
| 2         | 06/10/2022 00:00:00 | 1001     |          65 |
| 3         | 06/18/2022 00:00:00 | 1002     |          58 |
| 4         | 07/26/2022 00:00:00 | 1002     |          60 |
| 5         | 07/05/2022 00:00:00 | 1002     |          62 |

**Example Output:**

| model_id | avg_temperature |
|----------|----------------:|
| 1001     |            62.50 |
| 1002     |            60.00 |

**Answer:**

```sql
SELECT   model_id, AVG(temperature) AS avg_temperature
FROM     gpu_temps
GROUP BY 1
```

---

### 5. Can you describe the difference between a unique and a non-unique index?

While both types of indexes improve the performance of SQL queries by providing a faster way to lookup rows of data, a unique index enforces the uniqueness of the indexed columns while a non-unique index allows duplicate values in the indexed columns.

Suppose you had a table of NVIDIA employees. Here's an example of a unique index on the employee_id column:

```sql
CREATE UNIQUE INDEX employee_id_index
ON nvidia_employees (employee_id);
```

This index would ensure that no two NVIDIA employees have the same employee_id, which could be used as a unique identifier for each employee.

Here's a non-unique index example example on the job_title column:

```sql
CREATE INDEX job_title_index
ON nvidia_employees (job_title);
```

This index would not enforce uniqueness, but it could be used to improve the performance of queries that filter or sort the data based on the job_title column. For example, if you want to quicklly retreive all Data Scientists, the database can use the index to efficiently locate and retrieve the desired records without having to do a full table scan on all NVIDIA employees.

---


### 6. Calculate the Click-Through-Rates for NVIDIA Products

At NVIDIA, we utilize digital marketing strategies to ensure our customers are aware of our products. 

One essential metric we use to analyze the effectiveness of these strategies is the click-through rate (CTR). We would like you to calculate the CTR for every NVIDIA product for the past month.

Our `product_views` table records every time a user views one of our products:

`product_views` **Example Input:**

| view_id | user_id | view_date           | product_id |
|---------|---------|----------------------|------------|
| 1       | 123     | 09/01/2022 09:30:00 | 50001      |
| 2       | 265     | 09/01/2022 10:00:00 | 69852      |
| 3       | 362     | 09/02/2022 14:00:00 | 50001      |
| 4       | 192     | 09/03/2022 16:30:00 | 69852      |
| 5       | 981     | 09/04/2022 20:00:00 | 69852      |

Our `product_clicks` table records every time a user clicks on one of our products:

`product_clicks` **Example Input:**

| click_id | user_id | click_date           | product_id |
|----------|---------|----------------------|------------|
| 9076     | 123     | 09/01/2022 09:31:00 | 50001      |
| 7803     | 265     | 09/01/2022 10:02:00 | 69852      |
| 5294     | 362     | 09/02/2022 14:01:00 | 50001      |
| 6353     | 981     | 09/04/2022 20:03:00 | 69852      |

You should join the views and clicks according to user_id and product_id and then **calculate CTR as the number of clicks divided by the number of views for each product**.

**Answer:**

```sql
SELECT   v.product_id, 
         (CAST(COUNT(c.click_id) AS FLOAT) / COUNT(v.view_id)) * 100 AS click_through_rate
FROM     product_views v LEFT JOIN product_clicks c USING(product_id, user_id)
WHERE    v.view_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
         AND v.view_date < DATE_TRUNC('month', CURRENT_DATE)
GROUP BY 1
```

---

### 7. What does the FOREIGN KEY constraint do?

The FOREIGN KEY constraint is used to establish a relationship between two tables in a database. This ensures the referential integrity of the data in the database.

For example, if you have a table of NVIDIA customers and an orders table, the customer_id column in the orders table could be a FOREIGN KEY that references the id column (which is the primary key) in the NVIDIA customers table.


---

### 8. Customers and Purchases Data Analysis at NVIDIA

As a data analyst at NVIDIA, you are tasked with analyzing customer database and their purchases. There are two tables you can work with:

`customers` **Example Input:**

| customer_id | customer_name | customer_email         |
|-------------|----------------|-------------------------|
| 1           | John Doe      | johndoe@example.com     |
| 2           | Jane Smith    | janesmith@example.com   |
| 3           | Bob Johnson   | bob_johnson@example.com |
| 4           | Alice Davis   | alice_davis@example.com |
| 5           | Charlie White | charlie_white@example.com |


`purchases` **Example Input:**

| purchase_id | customer_id | product_id | purchase_date | product_price |
|-------------|-------------|------------|----------------|----------------|
| 101         | 1           | 50001      | 05/10/2022     | $1500         |
| 102         | 2           | 50002      | 05/15/2022     | $2500         |
| 103         | 3           | 50001      | 05/20/2022     | $1500         |
| 104         | 2           | 50001      | 05/22/2022     | $1500         |
| 105         | 1           | 50002      | 05/25/2022     | $2500         |

**Write a SQL query to get a list of all customers who bought the product with product_id = 50001 and the total amount they spent on that product.** 

Also, sort the output by total amount spent in descending order.

**Answer:**

```sql
SELECT   customer_name,
         SUM(product_price) as total_spent
FROM     customers c JOIN purchases p USING(customer_id)
WHERE    product_id = 50001
GROUP BY customer_id
ORDER BY 3 DESC
```

---

### 9. Obtaining Monthly Sales for each NVIDIA Product

As a Data Analyst in NVIDIA, you are asked to get a analysis of every product sold in the past year. 

You need to **retrieve the month, product ID and the total quantity sold for each product listed by NVIDIA on a monthly basis.**

Consider that fiscal year begins in January and ends in December. Use the sales table for your analysis.

Provided below are sample inputs and output for the problem:

`sales` **Example Input:**

| sale_id | sale_date           | product_id | quantity |
|---------|----------------------|------------|--------:|
| 1001    | 02/20/2021 12:14:00 | 50001      |       2 |
| 1002    | 02/25/2021 15:35:00 | 69852      |       1 |
| 1003    | 03/08/2021 11:11:00 | 50001      |       3 |
| 1004    | 03/14/2021 18:30:00 | 69852      |       5 |
| 1005    | 04/01/2021 09:09:00 | 50001      |       7 |

**Example Output:**

| month | product_id | total_quantity |
|-------|------------|---------------:|
| 2     | 50001      |              2 |
| 2     | 69852      |              1 |
| 3     | 50001      |              3 |
| 3     | 69852      |              5 |
| 4     | 50001      |              7 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM sale_date) AS month,
         product_id, 
         SUM(quantity) as total_quantity
FROM     sales
WHERE    EXTRACT(YEAR FROM sale_date) = 2021
GROUP BY 1, 2
ORDER BY 1, 2
```