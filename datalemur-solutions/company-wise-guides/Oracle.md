## 10 Oracle SQL Interview Questions

### 1. Analyzing Product Reviews

In an e-commerce company, product reviews are a vital part of understanding customer satisfaction. We have a `reviews` table which captures data from customers who have reviewed our products. 

This data includes the `review_id`, `user_id`, the date the review was submitted (`submit_date`), the `product_id`, and the number of `stars` given by the user.

**Write a SQL query that calculates the average number of stars given by month and product.** 

Also, provide the order by month and then by the average number of stars descending order.

`reviews` **Example Input:**

| review_id | user_id | submit_date         | product_id | stars |
|-----------|---------|----------------------|------------|-------|
| 6171      | 123     | 06/08/2022 00:00:00 | 50001      | 4     |
| 7802      | 265     | 06/10/2022 00:00:00 | 69852      | 4     |
| 5293      | 362     | 06/18/2022 00:00:00 | 50001      | 3     |
| 6352      | 192     | 07/26/2022 00:00:00 | 69852      | 3     |
| 4517      | 981     | 07/05/2022 00:00:00 | 69852      | 2     |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) AS mth, 
         product_id as product, 
         AVG(stars) OVER (PARTITION BY EXTRACT(MONTH FROM submit_date), product_id) AS avg_stars
FROM     reviews
ORDER BY 1, 3 DESC;
```

---

### 2. Designing Database for Oracle's Employee Training Program

Oracle is starting a new Employee Training Program and wants to keep track of each employee's progress. The program includes multiple courses, and each course may consist of several modules.

Every employee can take various courses and complete the modules at their own pace. Once an employee completes a module, their completion status and date are recorded. We need a database system to track this information and provide insights on the overall effectiveness of the program.

Design a database for tracking this scenario. Also, **write a SQL query that will generate a report showing the total number of courses every employee has completed.**

Assume the following example data for `Employee`, `Course`, `Module` and `EmployeeModule` tables.

`Employee` Table:

| employee_id | name | department |
|-------------|------|------------|
| 1           | John | Marketing  |
| 2           | Sara | Sales      |
| 3           | Bob  | HR         |

`Course` Table:

| course_id | name                   |
|-----------|-------------------------|
| 1         | Communication Skills   |
| 2         | Leadership Development |
| 3         | Team Building          |

`Module` Table:

| module_id | name                  | course_id |
|-----------|------------------------|-----------|
| 1         | Effective Communication| 1         |
| 2         | Decision Making        | 2         |
| 3         | Collaboration           | 3         |

`EmployeeModule` Table:

| employee_id | module_id | completed_date | status    |
|-------------|-----------|-----------------|-----------|
| 1           | 1         | 2022-06-25      | Completed |
| 1           | 2         | 2022-07-01      | Completed |
| 1           | 3         | 2022-07-10      | Completed |
| 2           | 1         | 2022-06-20      | Inprogress|
| 3           | 2         | 2022-07-10      | Completed |

**Answer:**

```sql
SELECT   e.name, COUNT(DISTINCT m.course_id) AS total_courses_completed
FROM     Employee e JOIN EmployeeModule em USING(employee_id)
                    JOIN Module m USING(module_id)
WHERE    em.status = 'Completed'
GROUP BY 1
```

---

### 3. Concept of Database Normalization

Normalizing a database involves dividing a large table into smaller and more specialized ones, and establishing relationships between them using foreign keys. 

This reduces repetition, resulting in a database that is more adaptable, scalable, and easy to maintain. Additionally, it helps to preserve the accuracy of the data by reducing the likelihood of inconsistencies and problems.

---

### 4. Click-through Conversion Rates Analysis for Oracle

Oracle is focusing on improving its digital marketing and sales strategy. You have a database that contains two tables: one for Clicks on digital ads (Table `clicks`) and one for Products added to the cart (Table `products_in_cart`).

The `clicks` table shows every click on a digital ad for a product, capturing the `product_id` and `user_id`. The `products_in_cart` table shows every time a product is added to the cart, also capturing the `product_id` and `user_id`.

**Calculate the click-through conversion rate for each `product_id`, defined as the number of times the product was added to the cart divided by the number of clicks on the product's ads.**

`clicks` **Example Input:**

| click_id | user_id | click_date           | product_id |
|----------|---------|----------------------|------------|
| 1023     | 534     | 06/09/2022 09:03:00 | 20010      |
| 2019     | 299     | 06/10/2022 13:37:00 | 20011      |
| 3035     | 467     | 06/11/2022 16:54:00 | 20010      |
| 4092     | 123     | 07/15/2022 11:00:00 | 20011      |
| 5011     | 867     | 07/20/2022 09:20:00 | 20010      |

`products_in_cart` **Example Input:**

| cart_id | user_id | add_to_cart_date     | product_id |
|---------|---------|----------------------|------------|
| 1523    | 534     | 06/09/2022 09:15:00 | 20010      |
| 2541    | 123     | 06/10/2022 13:49:00 | 20011      |
| 3570    | 467     | 06/11/2022 17:00:00 | 20010      |
| 4562    | 123     | 07/15/2022 12:00:00 | 20011      |
| 5502    | 458     | 07/20/2022 10:00:00 | 20011      |

**Answer:**

```sql
SELECT   c.product_id,
         COUNT(p.cart_id)::float/COUNT(c.click_id)::float as conversion_rate
FROM     clicks c LEFT JOIN products_in_cart p USING(product_id, user_id)
GROUP BY 1
```

---


### 5. Unique Indexes vs Non-Unique Indexes

Some similarities between unique and non-unique indexes include:

- Both types improve the performance of SQL queries by providing a faster way to lookup the desired data.

- Both types use an additional data structure to store the indexed data, which requires additional storage space which impacts write performance.
- Both types of indexes can be created on one or more columns of a table.

Some differences between unique and non-unique indexes include:

- A unique index enforces the uniqueness of the indexed columns, meaning that no duplicate values are allowed in the indexed columns. A non-unique index allows duplicate values in the indexed columns.

- A unique index can be used to enforce the primary key of a table, but a non-unique index cannot.
- A unique index can have a maximum of one NULL value in the indexed columns, but a non-unique index can have multiple NULLs

---

### 6. Average Sales Revenue by Product Category for Oracle

As a tech company, Oracle offers a diverse range of products including databases, cloud solutions, and other software services. The company would likely be interested in understanding the average sales revenue by product category.

The marketing team at Oracle wants to understand the **average sales revenue made for each product category each month.**

Given a relational table called 'sales' with columns `sales_id`(unique identifier for the sale), `product_id`(unique identifier for the product), `category_id`(unique identifier for product category), `sales_date`(date of the sale), and `revenue`(revenue from sale), **write an SQL query that retrieves the average revenue per product category for each month.**

`sales` **Example Input:**

| sales_id | product_id | category_id | sales_date | revenue |
|----------|------------|-------------|------------|---------|
| 1001     | 5001       | 1           | 06/18/2022 | 3500    |
| 1002     | 6985       | 2           | 06/18/2022 | 4700    |
| 1003     | 5001       | 1           | 07/27/2022 | 3700    |
| 1004     | 6985       | 2           | 08/25/2022 | 5000    |
| 1005     | 5000       | 1           | 06/18/2022 | 3000    |

**Example Output:**

| month | category | avg_revenue |
|-------|----------|-------------|
| 6     | 1        | 3250        |
| 6     | 2        | 4700        |
| 7     | 1        | 3700        |
| 8     | 2        | 5000        |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM sales_date) AS month,
         category_id AS category,
         AVG(revenue) AS avg_revenue
FROM     sales
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 7. What is the difference between a correlated subquery and non-correlated subquery?

A **correlated sub-query** is a sub-query that depends on the outer query and cannot be executed separately. It uses the outer query to filter or transform data by referencing a column from it, and the outer query uses the results of the inner query. In contrast, a **non-correlated sub-query** is independent of the outer query and can be executed on its own. It does not reference any columns from the outer query and is used to retrieve additional data needed by the outer query.

Here is an example of a correlated sub-query:

```sql
SELECT t1.customer_id, t1.total_sales
FROM oracle_sales t1
WHERE t1.total_sales > (
  SELECT AVG(t2.total_sales)
  FROM oracle_sales t2
  WHERE t2.customer_id = t1.customer_id
);
```

This query selects the `customer_id` and `total_sales` of all Oracle customers in the `sales` table whose `total_sales` are greater than the average `total_sales` of their own customer group. The sub-query in this case is correlated with the outer query, as it references the `customer_id` column from the outer query (`t1.customer_id`).

Here is an example of a non-correlated sub-query:

```sql
SELECT t1.customer_id, t1.total_sales
FROM   oracle_sales t1
WHERE  t1.total_sales > (
  SELECT AVG(t2.total_sales)
  FROM   3oracle_sales t2
);
```

The sub-query in this case is non-correlated, as it does not reference any columns from the outer query.

Performance-wise, correlated sub-queries are generally slower to execute, as they have to be re-evaluated for each row of the outer query, while non-correlated sub-queries are faster, as they only have to be executed once.

---

### 8. Filter Records with Company-Specific Data

You are the Database Administrator for Oracle. The company maintains a database of its customers. The database `oracle_customers` has a table `customers` with details such as `customer_id`, `first_name`, `last_name`, `email_id` and `company_name`.

Your task is to **create a SQL query that will filter down the records of customers who are from any company that has the string 'Oracle' in its name** (it could be Upper Case or Lower Case or a mix of both).

`customers` **Example Input:**

| customer_id | first_name | last_name | email_id             | company_name    |
|-------------|------------|------------|----------------------|-----------------|
| 001         | John       | Doe       | john.doe@example.com | Oracle          |
| 002         | Jane       | Smith     | jane.smith@example.com| Microsoft      |
| 003         | Mary       | Johnson   | mary.johnson@example.com| Oracle Solutions|
| 004         | James      | Brown     | james.brown@example.com| Google         |
| 005         | Patricia   | Miller    | patricia.miller@example.com| Oracle Cloud   |

**Example Output:**

| customer_id | first_name | last_name | email_id             | company_name    |
|-------------|------------|------------|----------------------|-----------------|
| 001         | John       | Doe       | john.doe@example.com | Oracle          |
| 003         | Mary       | Johnson   | mary.johnson@example.com| Oracle Solutions|
| 005         | Patricia   | Miller    | patricia.miller@example.com| Oracle Cloud   |

**Answer:**

```sql
SELECT *
FROM   customers
WHERE  lower(company_name) LIKE '%oracle%';
```


---

### 9. Average Purchase Amount by Age Groups

A common analysis is to calculate the average purchase amount by age groups. Use the `customer` and `purchases` tables.

The `customer` table has such columns: `customer_id`, `first_name`, `last_name`, `birthdate`.

The `purchases` table includes `purchase_id`, `customer_id`, `purchase_date`, `product_id`, `amount`.

We want to join these tables based on `customer_id`, **calculate the age of customers, group them into age bins, and calculate the average purchase amount for each age group**.

`customer` **Example Input:**

| customer_id | first_name | last_name | birthdate  |
|-------------|------------|------------|------------|
| 1001        | John       | Doe       | 1980-05-01 |
| 1002        | Jane       | Smith     | 1990-10-30 |
| 1003        | Jim        | Brown     | 2000-01-20 |
| 1004        | Jill       | Jones     | 1965-07-05 |
| 1005        | Bob        | Johnson   | 1975-12-15 |

`purchases` **Example Input:**

| purchase_id | customer_id | purchase_date | product_id | amount |
|-------------|-------------|----------------|------------|--------|
| 8223        | 1001        | 2022-07-10     | 70001      | 200.00 |
| 8315        | 1002        | 2022-08-05     | 80052     | 150.00  |
| 8236        | 1003        | 2022-06-18     | 70009     | 220.00  |
| 8252        | 1004        | 2022-05-15     | 80952     | 180.00  |
| 8301        | 1005        | 2022-11-05     | 80882     | 250.00  |

**Answer:**

```sql
SELECT 
    CASE
        WHEN age <= 30 THEN '0-30'
        WHEN age > 30 AND age <= 50 THEN '30-50'
        WHEN age > 50 THEN '> 50'
    END AS age_group,
    AVG(amount) as avg_amount
FROM    
    (
        SELECT p.*, 
               c.birthdate,
               EXTRACT(year FROM AGE(p.purchase_date, c.birthdate)) AS age
        FROM   purchases p JOIN customer c USING(customer_id)
    ) X
GROUP BY 1
ORDER BY 1
```


---

### 10. Determine Records in One Table Not Present in Another

To find records in one table that aren't in another, you can use a `LEFT JOIN` and check for `NULL` values in the right-side table.

Here is an example using two tables, `oracle_employees` and `oracle_managers`:

```sql
SELECT *
FROM   oracle_employees LEFT JOIN oracle_managers ON oracle_employees.id = oracle_managers.id
WHERE  oracle_managers.id IS NULL;
```

This will return all rows from `oracle_employees` where there is no matching row in `managers` based on the `id` column.

You can also use the `EXCEPT` operator in PostgreSQL and Microsoft SQL Server to return the records that are in the first table but not in the second. Here is an example:

```sql
SELECT * 
FROM   oracle_employees

EXCEPT

SELECT * 
FROM   oracle_managers
```

This will retrieve all rows from `employees` that do not appear in `managers`. The `EXCEPT` operator works by retrieving the rows that are returned by the first query, but not by the second.

Please note that `EXCEPT` is not supported by all DBMS systems, such as MySQL and Oracle (however, you can use the `MINUS` operator to achieve a similar outcome).


---