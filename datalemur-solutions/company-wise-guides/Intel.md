## 10 Intel SQL Interview Questions


### 1. Compute Average Product Review Ratings Per Month

**Question:**
Intel is interested in evaluating the performance of its products based on user reviews. Given the reviews table that contains a product's ID, the date the review was submitted, and a user's given star rating (1 through 5), write a SQL query to compute the average star rating for each product per month.

**Example Input** (reviews):
| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|-------------|------------|-------|
| 6171      | 123     | 06/08/2022  | 50001      | 4     |
| 7802      | 265     | 06/10/2022  | 69852      | 4     |
| 5293      | 362     | 06/18/2022  | 50001      | 3     |
| 6352      | 192     | 07/26/2022  | 69852      | 3     |
| 4517      | 981     | 07/05/2022  | 69852      | 2     |

**Example Output:**
| mth | product_id | avg_stars |
|-----|------------|-----------|
| 6   | 50001      | 3.50      |
| 6   | 69852      | 4.00      |
| 7   | 69852      | 2.50      |

**Answer:**

```sql
SELECT   CAST(EXTRACT(month from submit_date) AS INTEGER) AS mth,
         product_id,
         AVG(stars)
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 2. Intel Products Manufacturing Data

**Question:**

Intel, as a pioneering company in the semiconductor industry, has a large scale of manufacturing operations. There is a continuous need to monitor and analyze the manufacturing data to drive optimizations and maintain high-quality standards. Let's assume Intel has a products table that keeps track of each product and its manufacturing details, and an inspection table that stores the quality inspection results for each product.

Our task is to design related database tables, and write a PostgreSQL query to find and list all products that have failed quality inspection more than once last month.
 
**Example Input** (products):

| product_id | product_name | manufacturing_date |
|------------|--------------|-------------------|
| 01         | Processor_A  | 2022-06-18        |
| 02         | Processor_B  | 2022-06-20        |
| 03         | Memory_C     | 2022-06-21        |
| 04         | Memory_D     | 2022-06-25        |
| 05         | Modem_E      | 2022-06-26        |

**Example Input** (inspection):

| inspection_id | product_id | inspection_date | result |
|----------------|------------|-----------------|--------|
| 1001           | 01         | 2022-07-01      | Pass   |
| 1002           | 01         | 2022-07-08      | Fail   |
| 1003           | 02         | 2022-07-10      | Fail   |
| 1004           | 02         | 2022-07-12      | Pass   |
| 1005           | 02         | 2022-07-15      | Fail   |

**Answer:**

```sql
WITH failed_inspection_cte AS (
    SELECT   product_id, 
             COUNT(inspection_id) AS failed_inspection_count
    FROM     inspection
    WHERE    result = 'Fail' AND DATE_PART('month', inspection_date) = DATE_PART('month', CURRENT_DATE - INTERVAL '1 month')
    GROUP BY 1
    HAVING   COUNT(inspection_id) > 1
)
SELECT p.product_name, 
       failed_inspection_count
FROM   products p JOIN failed_inspection_cte USING(product_id)
```

---

### 3. Can you describe the role of the CHECK constraint and provide an example of a situation where it might be applied?

The CHECK constraint is used to enforce rules on the data in a specific column. If a row is inserted or updated with data that does not follow the CHECK constraint's rule, the operation will fail.

For example, say you had a database that stores ad campaign data from Intel's Google Analytics account. Here's what some constraints could look like:

```sql
CREATE TABLE ad_campaigns (
    ad_id INTEGER PRIMARY KEY,
    ad_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget DECIMAL(10,2) NOT NULL CHECK (budget > 0),
    cost_per_click DECIMAL(10,2) NOT NULL CHECK (cost_per_click > 0)
);
```

In this example, the CHECK constraint is used to ensure that the "budget" and "cost_per_click" fields have positive values. This helps to ensure that the data in the database is valid and makes sense in the context of ad campaigns.

You can also use the CHECK constraint to ensure that data meets other specific conditions. For example, you could use a CHECK constraint to ensure that the "start_date" is before the "end_date" for each ad campaign.

---

### 4. Calculating Click-through-rate for Intel Ads

**Question:**

Given a table of user click events on Intel's digital advertisement and another table for user purchases, calculate the click-through conversion rate, defined as the number of users who made a purchase after clicking the ad divided by the total number of users who clicked the ad.

**Example Input** (ad_clicks):

| click_id | user_id | click_time | ad_id |
|----------|---------|------------|-------|
| 4012     | 001     | 06/10/2022 12:00:00 | 8451 |
| 1435     | 002     | 06/10/2022 14:00:00 | 5984 |
| 6541     | 003     | 06/11/2022 08:00:00 | 8451 |
| 9765     | 004     | 06/11/2022 10:00:00 | 8451 |
| 3568     | 005     | 06/12/2022 20:00:00 | 5984 |

**Example Input** (purchases):

| purchase_id | user_id | purchase_date | product_id |
|-------------|---------|----------------|------------|
| 0451        | 001     | 06/10/2022 15:00:00 | 8923 |
| 3782        | 001     | 06/10/2022 16:00:00 | 3398 |
| 8600        | 002     | 06/10/2022 17:00:00 | 1112 |
| 7416        | 006     | 06/12/2022 12:00:00 | 8923 |
| 9928        | 003     | 06/12/2022 23:00:00 | 1112 |

**Answer:**

```sql
WITH clicks AS (
    SELECT user_id
    FROM   ad_clicks
),
purchases AS (
    SELECT user_id
    FROM   purchases
    WHERE  user_id IN (SELECT user_id FROM clicks)
),
total_clicks AS (
    SELECT COUNT(*) as total
    FROM   clicks
),
total_purchases AS (
    SELECT COUNT(*) as total
    FROM   purchases
)
SELECT (tp.total::decimal / tc.total)* 100 as CTR
FROM   total_clicks tc, total_purchases tp
```

---

### 5. What's the purpose of the COALESCE() function in SQL?

The COALESCE() function accepts an unlimited number of input arguments, and returns the first argument from that list which isn't null. If all input arguments are null, COALESCE will return null too.

For example, suppose you had data on Intel salespeople, and the amount of deals they closed. This data was exported from a 3rd-party system CRM, which exports a NULL value if the salesperson didn't close any deals.


sales_person | closed_deals|
------------|-------------
Jason Wright | 4|
Drew Jackson | NULL|
Chris Ho     | 2|
Adam Cohen   | NULL|
Samantha Perez | 3|


To get rid of these NULLs, and replace them with zero's (so you can do some further analytics like find the average number of closed deals), you would use the COALESCE() function as follows:

```sql
SELECT name, COALESCE(closed_deals, 0) as closed_deals
FROM   intel_salespeople
```

You'd get the following output:


sales_person | closed_deals |
------------ |-------------
Jason Wright | 4 |
Drew Jackson | 0 |
Chris Ho     | 2 |
Adam Cohen   | 0 |
Samantha Perez | 3 |

---

### 6. Average Rating per CPU Product
**Question:**
In Intel, we are interested in the performance and quality of our CPU (Central Processing Unit) products over time. One way of gauging product performance is by analyzing the ratings given by our customers. As a data analyst, we need you to write a query that will provide us with the average rating (stars) per CPU product for each year.

For this question, we are assuming that we have 2 tables. The first table is products and the other is reviews.

**Example Input** (products):
| product_id | cpu_model |
|------------|-----------|
| 1 | core i7 |
| 2 | core i5 |  
| 3 | core i3 |
| 8 | pentium |

**Example Input** (reviews):
| review_id | product_id | review_date | stars |
|-----------|------------|-------------|-------|
| 1 | 3 | 01/03/2020 | 5 |
| 2 | 1 | 12/03/2019 | 4 |
| 3 | 2 | 11/11/2019 | 5 |
| 4 | 1 | 12/06/2020 | 3 |
| 5 | 3 | 05/30/2019 | 4 |
| 6 | 2 | 08/09/2020 | 5 |

**Answer:**

```sql
SELECT   EXTRACT(YEAR FROM review_date) as year,
         p.cpu_model as product,
         ROUND(AVG(stars)::numeric, 2) as avg_stars
FROM     reviews r JOIN products p USING(product_id)
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 7. What are the different kinds of joins in SQL?

In SQL, a join retrieves rows from multiple tables and combines them into a single result set.

Four JOIN types can be found in SQL. For an example of each one, suppose you had a table of Intel orders and Intel customers.

**INNER JOIN**: Rows from both tables are retrieved when there is a match in the shared key or keys. An INNER JOIN between the Orders and Customers tables would return only rows where the customer_id in the Orders table matches the customer_id in the Customers table.

**LEFT JOIN**: A LEFT JOIN retrieves all rows from the left table (in this case, the Orders table) and any matching rows from the right table (the Customers table). If there is no match in the right table, NULL values will be returned for the right table's columns.

**RIGHT JOIN**: A RIGHT JOIN combines all rows from the right table (in this case, the Customers table) and any matching rows from the left table (the Orders table). If there is no match in the left table, NULL values will be displayed for the left table's columns.

**FULL OUTER JOIN**: A FULL OUTER JOIN combines all rows from both tables, regardless of whether there is a match in the shared key or keys. If there is no match, NULL values will be displayed for the columns of the non-matching table.

---

### 8. Find Intel Employees

**Question:**

Intel Corp. wants to filter through its employee database to find employees who have 'Systems Engineer' in their job titles and who got hired in the year 2020. The 'employees' table consists of the fields 'employee_id', 'name', 'job_title', 'hire_date', 'salary' and 'dept_name'.

**Example Input** (employees):

| employee_id | name | job_title | hire_date | salary | dept_name |
|-------------|------|-----------|-----------|--------|-----------|
| 2312 | John Doe | Systems Engineer | 2020-05-17 | 60000 | Software |
| 8725 | Diana Prince | Software Developer | 2019-09-10 | 75000 | Software |
| 6139 | Clark Kent | Systems Analyst | 2018-03-24 | 53000 | Systems |
| 9408 | Bruce Wayne | Systems Engineer | 2020-01-15 | 62000 | Systems |
| 7690 | Peter Parker | Database Administrator | 2021-06-12 | 56000 | Database |

**Expected Output:**

| employee_id | name | job_title | hire_date | salary | dept_name |
|-------------|------|-----------|-----------|--------|-----------|
| 2312 | John Doe | Systems Engineer | 2020-05-17 | 60000 | Software |
| 9408 | Bruce Wayne | Systems Engineer | 2020-01-15 | 62000 | Systems |

**Answer:**

```sql
SELECT *
FROM   employees
WHERE  job_title LIKE '%Systems Engineer%' and EXTRACT(YEAR FROM hire_date) = 2020;
```

---

### 9. Purchase Analysis Combined From Customers and Products

**Question:**

Analyze the purchasing behavior of Intel's customers and identify the most bought product. The analysis will be based on two tables: customers and purchases.

The customers table has five columns: customer_id, first_name, last_name, email and created_at (the date when the customer was added).

**Example Input** (customers):

| customer_id | first_name | last_name | email | created_at |
|-------------|------------|-----------|-------|------------|
| 1 | John | Doe | johndoe@example.com | 2020/10/21 |
| 2 | Jane | Smith | janesmith@example.com | 2020/11/03 |
| 3 | Dave | Jones | davejones@example.com | 2021/01/15 |
| 4 | Mary | Johnson | maryjohnson@example.com | 2021/04/25 |
| 5 | Robert | Brown | robertbrown@example.com | 2021/08/12 |

The purchases table has four columns: purchase_id, customer_id (linked to the customers table), product_id and purchase_date.

**Example Input** (purchases):

| purchase_id | customer_id | product_id | purchase_date |
|-------------|-------------|------------|----------------|
| 100 | 1 | 15 | 2020/10/22 |
| 101 | 2 | 17 | 2021/03/17 |
| 102 | 1 | 18 | 2021/06/29 |
| 103 | 4 | 15 | 2021/06/01 |
| 104 | 1 | 17 | 2021/09/10 |
| 105 | 2 | 15 | 2022/01/10 |

The question is to write a SQL query that returns the most purchased product by customers in Intel. If more than one product has the most purchases, return all of them.

**Answer:**

```sql
-- my solution

SELECT   product_id, COUNT(*) as count
FROM     purchases
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1


-- alternate site's solution: 

SELECT   product_id, COUNT(*) AS purchase_count
FROM     purchases
GROUP BY 1
HAVING   COUNT(*) = (
        SELECT MAX(purchase_count) 
        FROM   (
            SELECT   COUNT(*) AS purchase_count
            FROM     purchases
            GROUP BY product_id
        ) as total_counts
    )
```

---


### 10. What sets the 'BETWEEN' and 'IN' operators apart?

The BETWEEN and IN operators are both used to filter data based on certain criteria, but they work in different ways. 

BETWEEN is used to select values within a range, while IN is used to select values that match a list.

For instance, if you have a table called `intel_employees` that contains the salary of each employee, along with which country they reside in, you could use the `BETWEEN` operator to find all employees who make between 130k and 160k:

```sql
SELECT * 
FROM   intel_employees 
WHERE  salary BETWEEN 130000 AND 160000;
```

To find all employees that reside in France and Germany, you could use the IN operator:

```sql
SELECT * 
FROM   intel_employees 
WHERE  country IN ("France", "Germany");
```
---