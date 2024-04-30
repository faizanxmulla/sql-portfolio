## 10 Fortinet SQL Interview Questions

### 1. Calculate average monthly sales and rank products
Assuming Fortinet is a company that sells cybersecurity products, you are given a sales table with the following columns:

- sales_id (unique identifier for each sale)

- product_id (identifier for the product sold)  
- sale_date (the date of the sale in MM/DD/YYYY format)
- sale_amount (the dollar amount of the sale)

**Write a SQL query that calculates average monthly sales for each product and rank the products based on their average monthly sales in descending order.**

`sales` Example Input:
| sales_id | product_id | sale_date           | sale_amount |
|-----------|------------|----------------------|-------------|
| 9912     | 207        | 06/08/2022 00:00:00 | 85.20       |
| 7802     | 49         | 06/10/2022 00:00:00 | 121.50      |
| 5293     | 207        | 06/18/2022 00:00:00 | 90.37       |
| 6352     | 49         | 07/26/2022 00:00:00 | 94.25       |
| 4517     | 49         | 07/05/2022 00:00:00 | 98.15       |

Example Output:
| month_year | product_id | avg_monthly_sale | rank |
|------------|------------|-------------------|-------|
| 6/2022     | 207        | 87.79            | 1     |
| 6/2022     | 49         | 121.50           | 2     |
| 7/2022     | 49         | 96.20            | 1     |

Answer:
```sql
WITH sales_cte as (
	SELECT   product_id, 
  			 TO_CHAR(sale_date, 'MM/YYYY') as month_year, 	  
             ROUND(AVG(sale_amount)::INTEGER, 2) as avg_monthly_sales
	FROM     sales
	GROUP BY 1, 2
)
SELECT *, RANK() OVER(PARTITION BY month_year ORDER BY avg_monthly_sales desc)
FROM   sales_cte
```
---

### 2. Fortinet Product Sales Analysis
As a database manager for Fortinet, you are tasked to understand the product sales pattern over different geographical regions. The company wants to know the top selling product in each region for the last quarter.

The company has two main tables namely: 'sales' and 'products'

`sales` Example Input:

| sale_id | sale_date | product_id | region        | units_sold |
|---------|-----------|------------|---------------|------------|
| 1       | 2022-04-01| 101        | North America | 10         |
| 2       | 2022-04-15| 102        | Europe        | 7          |
| 3       | 2022-05-20| 101        | Asia          | 15         |
| 4       | 2022-06-10| 103        | Europe        | 12         |
| 5       | 2022-06-22| 102        | North America | 8          |


`products` Example Input:
| product_id | product_name | product_price |
|------------|--------------|---------------|
| 101        | FortiGate60E | 1200          |
| 102        | FortiGate80E | 2300          |
| 103        | FortiWiFi45E | 900           |

**Write a SQL query to display the top selling product in each region for the last quarter.**


Answer:
```sql
SELECT   region, product_id, product_name, SUM(units_sold) as total_units_sold
FROM     sales s JOIN products p USING(product_id)
WHERE    sale_date >= date_trunc('quarter', current_date)
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT    1;
```

---

### 3. Are the results of a UNION ALL and a FULL OUTER JOIN usually the same?

No, in almost all cases, and for all practical purposes, UNION ALL and FULL OUTER JOIN do NOT produce the same result.

While both are similar, in that they combine two tables, you can think of joins as increasing the width of the resulting table (you'll have more columns in the result set for a left/inner/right join), whereas a union is used to combine rows which increases the height of the result set but keeps the column count the same.

---

### 4. Filter Fortinet's Customer Data Based on Purchase History and Location
You are given a table named customers containing customer data for Fortinet. The customers table has the following columns:

- 'customer_id', an integer,

- 'first_name' and 'last_name', both strings representing the customers' first and last names,

- 'country', a string representing the customers' country,

- 'purchase_amount', a floating point value representing the total amount the customer has purchased,

- 'purchase_date', a string representing the date of purchase in 'MM/DD/YYYY' format.

**Write a SQL query to select all customers from the United States (country = 'United States') who have made a total purchase of more than $1000 (purchase_amount > 1000) during the year 2021.**

Please note that the 'purchase_date' is in date format and you must parse it to filter the year 2021.

`customers` Example Input:

| customer_id | first_name | last_name | country        | purchase_amount | purchase_date |
|-------------|------------|-----------|----------------|------------------|---------------|
| 8182        | John       | Doe       | United States  | 1200             | 03/15/2021    |
| 9393        | Jane       | Woods     | Canada         | 550              | 07/26/2021    |
| 5612        | Alice      | Smith     | United States  | 800              | 10/18/2021    |
| 7793        | Robert     | Brown     | United States  | 2000             | 04/08/2021    |
| 6584        | Charlie    | Black     | United Kingdom | 900              | 06/10/2021    |

Answer:

```sql
SELECT *
FROM   customers
WHERE  country = 'United States' AND 
       purchase_amount > 1000 AND 
       DATE_PART('year', TO_DATE(purchase_date, 'MM/DD/YYYY')) = 2021;
```
---

### 5. Can you give an example of a one-to-one relationship between two entities, vs. a one-to-many relationship?

In database schema design, a **one-to-one relationship** between two entities is where each entity is associated with only one instance of the other entity. For example, the relationship between a US citizen and their social-security number (SSN) is one-to-one, because each citizen can only have one SSN, and each SSN belongs to exactly one person.

On the other hand, a **one-to-many relationship** is where one entity can be associated with multiple instances of the 2nd entity. For example, each person can be associated with multiple email addresses, but each email address only relates back to one person.

---

### 6. Calculate the Average Number of Alert Notifications Per Firewall System

As an IT security company, Fortinet supplies various Firewall systems to secure a company's network. Every Firewall system sends alert notifications depending on the level of security threats. 

Your task is to calculate the average number of alert notifications each type of Firewall system sends daily.

`firewall_alerts` Example Input:

| **alert_id** | **firewall_id** | **firewall_type** | **alert_date** |
|:-------------|:----------------|:------------------|:---------------|
| 13896       | 200             | Basic            | 11/18/2022     |
| 15552       | 500             | Advanced         | 11/18/2022     |
| 16353       | 200             | Basic            | 11/18/2022     |
| 18451       | 1000            | Premium          | 11/19/2022     |
| 17787       | 500             | Advanced         | 11/19/2022     |
| 14458       | 1000            | Premium          | 11/19/2022     |
| 17419       | 1000            | Premium          | 11/20/2022     |

Example Output:

| **firewall_type** | **avg_daily_alerts** |
|:------------------|:--------------------|
| Basic             | 1                   |
| Advanced          | 1                   |
| Premium           | 2                   |

Answer:

```sql
WITH cte as (
	SELECT   firewall_id, firewall_type, COUNT(alert_id) as alert_count
	FROM     firewall_alerts
	GROUP BY 1, 2, alert_date
)
SELECT   firewall_id, firewall_type, ROUND(AVG(alert_count), 2) AS avg_alert_count
FROM     cte
GROUP BY 1, 2
```

---

### 7. What's a cross-join, and why are they used?

A cross-join, also known as a cartesian join, is a JOIN that produces the cross-product of two tables. In a cross-join, each row from the first table is matched with every row from the second table, resulting in a new table with a row for each possible combination of rows from the two input tables.

Let's say you were building a Machine Learning model that attempts to score the probability of a customer purchasing a Fortinet product. Before working in Pandas and Tensorflow, you might want to do some Exploratory Data Analysis (EDA) in SQL, and generate all pairs of customers and Fortinet products.

Here's a cross-join query you could run:

```sql
SELECT customers.id AS customer_id, fortinet_products.id AS product_id
FROM customers
CROSS JOIN fortinet_products;
```
Cross-joins are useful for generating all possible combinations, but they can also create huge tables if you're not careful. For instance, if you had 10,000 potential customers and Fortinet had 500 different product SKUs, the resulting cross-join would have 5 million rows!

---

### 8. Monthly Average Sales of Fortinet Products

Fortinet is a cybersecurity company that produces and sells products like firewalls, anti-virus software, intrusion prevention systems etc. As an SQL analyst, your task is to determine the monthly average sales of each product.

Suppose we have a sales table that keeps track of all Fortinet products sold. The table has rows representing individual transactions, with each row containing the product_id, transaction_id, sale_date (in the format YYYY-MM-DD), and units_sold.

`sales` Example Input:
| transaction_id | product_id | sale_date | units_sold |
|----------------|------------|-----------|------------|
| 6512           | 1001       | 2022-01-12| 15         |
| 1730           | 1002       | 2022-01-14| 20         |
| 9203           | 1001       | 2022-01-23| 12         |
| 5101           | 1003       | 2022-01-30| 30         |
| 2549           | 1002       | 2022-02-03| 19         |
| 8600           | 1001       | 2022-02-14| 17         |
| 4502           | 1003       | 2022-02-18| 25         |
| 3626           | 1001       | 2022-02-28| 20         |

We want to know the **average units of each product sold per month**.

Example Output:

| month | product | average_units_sold |
|-------|---------|-------------------|
| 1      | 1001    | 13.50             |
| 1      | 1002    | 20.00             |
| 1      | 1003    | 30.00             |
| 2      | 1001    | 18.50             |
| 2      | 1002    | 19.00             |
| 2      | 1003    | 25.00             |

Answer:
```sql
SELECT   EXTRACT(MONTH from sale_date) as month,
         product_id as product,
         AVG(units_sold) as average_units_sold
FROM     sales
GROUP BY 1, 2
ORDER BY 1, 2
```
---

### 9. Employee Salary Calculation

In Fortinet, the salary details are tracked in a 'salary' table for each employee. Employees can receive bonuses based on the total number of successful projects which are tracked in the 'projects' table. 

The bonus is calculated as follows - the square root of the successful projects count times the absolute value of the difference between 7 (indicating all days of the week that they might have worked) and the actual working days in a week. 

The total salary is the current salary plus the calculated bonus rounded to 2 decimal places.

**Write a query to get the employeeID, employee name, original salary, bonus, and the calculated total salary for each employee.**

Tables:

`salary` Example Input:

| employee_id | name | current_salary (in $) | working_days_in_week |
|-------------|------|------------------------|----------------------|
| 101         | John | 5500                   | 5                    |
| 102         | Lucy | 6200                   | 6                    |
| 103         | Tom  | 7000                   | 4                    |
| 104         | Cindy| 5800                   | 5                    |

`projects` Example Input:
| project_id | employee_id | status   |
|------------|-------------|----------|
| 1          | 101         | Success  |
| 2          | 101         | Success  |
| 3          | 101         | Fail     |
4 |	102 |	Success |
5 |	103 |	Success |
6 |	103 |	Success |
7 |	104 |	Success |
8 |	104 |	Success |
9 |	104 |	Fail |



Answer:
```sql
SELECT s.employee_id, s.name, s.current_salary, 
       ROUND(SQRT(p.count_projects) * ABS(s.working_days_in_week - 7), 2) AS bonus, 
       ROUND(s.current_salary + SQRT(p.count_projects) * ABS(s.working_days_in_week - 7), 2) AS total_salary
FROM   salary s
JOIN (
  SELECT   employee_id, COUNT(*) as count_projects
  FROM     projects
  WHERE    status = 'Success'
  GROUP BY 1
) p ON s.employee_id = p.employee_id;
```

---

### 10. When it comes to database normalization, what's the difference between 1NF, 2NF, and 3NF?

There are several normal forms that define the rules for normalizing a database:

A database is in **first normal form (1NF)** if it meets the following criteria:

 - Each column in a table contains a single value (no lists or containers of data)

 - Each column should contain the same type of data (no mixing strings vs. integers)
 - Each row in the table is unique


A database is in **second normal form (2NF)** if it meets the following criteria:

- It is in first normal form.

- All non-key attributes in a table are fully dependent on the primary key.

Said another way, to achieve 2NF, besides following all the rules from 1NF all the columns in a given table should be dependent only on that table's primary key.

A database is in **third normal form (3NF)** if it meets the following criteria:

- It is in second normal form.

- There are no transitive dependencies in the table.

A transitive dependency means that a piece of data in one column is derived from another column. For example, it wouldn't make sense to keep a column called "user's age" and "user's birthdate" (because age can be derived from birthdate)

---