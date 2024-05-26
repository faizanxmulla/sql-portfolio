## 10 Palo Alto Networks SQL Interview Questions

### 1. Analyzing Power Users of Palo Alto Network's Products

Palo Alto Networks provides protection to hundreds of thousands of companies. One of their keys to success is understanding their power users - users who make frequent and high-value purchases. 

For the sake of this exercise, let's define a 'power user' as a customer who has purchased more than 10 different products (uniqueness determined by product_id) and whose total purchase value exceeds $10,000.

The company has a `sales` table that model some hypothetical data that contains the following columns:

- `sale_id` (int) – The unique identifier of a sale.

- `user_id` (int) – The unique identifier of a user.
- `purchase_date` (timestamp) – The date when the product was purchased.
- `product_id` (int) – The unique identifier of a product.
- `price` (decimal) - The price of the product when it was sold.

**Write a SQL query that can identify these power users.** 

The output should include user_ids and total purchase value of all power users, sorted in descending order by total purchase value.

`sales` **Example Input:**


| sale_id | user_id | purchase_date       | product_id | price |
|---------|---------|----------------------|------------|-------|
| 1001    | 300     | 01/01/2022 00:00:00 | 500        | 200.00|
| 1002    | 305     | 01/03/2022 00:00:00 | 505        | 800.00|
| 1003    | 300     | 02/01/2022 00:00:00 | 501        | 250.00|
| 1004    | 310     | 02/07/2022 00:00:00 | 502        | 150.00|
| 1005    | 300     | 02/15/2022 00:00:00 | 503        | 350.00|
| 1006    | 305     | 02/20/2022 00:00:00 | 506        | 1100.00|
| 1007    | 300     | 03/01/2022 00:00:00 | 504        | 200.00|

**Answer:**

```sql
WITH products_cte as (
    SELECT user_id, 
           COUNT(product_id) OVER(PARTITION BY user_id) as purchased_pdts_count, 
           price
    FROM   sales
)
SELECT   user_id, 
		 SUM(purchased_pdts_count), 
	     SUM(price) as total_price
FROM     products_cte
WHERE    purchased_pdts_count > 1
GROUP BY 1
HAVING   SUM(price) > 10000
ORDER BY 2 DESC
```

---

### 2. Calculate the daily average issue response time

As a network security company, Palo Alto Networks regularly deals with issues raised by its customers. For this scenario, assume that each issue has a unique id, a start time when the issue was reported, and an end time when the issue was resolved. All times are recorded in UTC.

Your task is to **calculate the daily average response time for issues**. 

Average response time for a day is defined as the average of the time differences (in minutes) between the end time and the start time of each issue reported that day.

Use the `issues` table for this problem.

`issues` **Example Input:**


| issue_id | start_time          | end_time            |
|----------|----------------------|----------------------|
| 1001     | 2022-07-01 08:30:00 | 2022-07-01 09:30:00 |
| 1002     | 2022-07-01 09:00:00 | 2022-07-01 09:45:00 |
| 1003     | 2022-07-02 10:00:00 | 2022-07-02 11:00:00 |
| 1004     | 2022-07-02 11:00:00 | 2022-07-02 12:30:00 |
| 1005     | 2022-07-03 11:00:00 | 2022-07-03 14:00:00 |

**Example Output:**

| date       | average_response_time |
|------------|------------------------|
| 2022-07-01 | 52.50                 |
| 2022-07-02 | 75.00                 |
| 2022-07-03 | 180.00                |

**Answer:**

```sql
SELECT   TO_CHAR(start_time, 'YYYY-MM-DD') AS date,
         ROUND(AVG(EXTRACT(EPOCH FROM (end_time - start_time)) / 60), 2) AS average_response_time 
FROM     issues 
GROUP BY 1
ORDER BY 1
```

---

### 3. What's a foreign key?

A foreign key is a column or group of columns in a table that refers to the primary key in another table. The foreign key constraint helps maintain referential integrity between the two tables. The table with the foreign key is called the child table, while the table with the candidate key is called the parent or referenced table.

For example, consider a database with two tables: `palo_alto_networks_customers` and `palo_alto_networks_orders`. The `Customers` table might have a primary key column called `customer_id`, while the `Palo Alto Networks orders` table might have a foreign key column called `customer_id` that references the `customer_id` column in `Palo Alto Networks customers` table.

---

### 4. Calculate Click-Through-Rate for Palo Alto Networks Ads

Suppose that Palo Alto Networks wants to assess the effectiveness of its recent digital ads campaign. The company tracks two main user activities; the number of times an ad has been viewed (`ad_views`) and the number of times a viewed ad leads to a click (`ad_clicks`). The click-through-rate (CTR) can be calculated by dividing the number of ad clicks by the number of ad views.

Given two tables, `ad_views` and `ad_clicks`, with each row in `ad_views` representing a single view of an ad and each row in `ad_clicks` representing a single click on an ad, determine the overall click-through-rate for Palo Alto Networks ads.

**Example Input:**

`ad_views`:

| view_id | user_id | view_date           | ad_id |
|---------|---------|----------------------|-------|
| 12345   | 555     | 06/04/2022 00:00:00 | 1001  |
| 23456   | 666     | 06/05/2022 00:00:00 | 1002  |
| 34567   | 777     | 06/06/2022 00:00:00 | 1003  |
| 45678   | 888     | 06/07/2022 00:00:00 | 1004  |

`ad_clicks`:

| click_id | user_id | click_date          | ad_id |
|----------|---------|----------------------|-------|
| 54321    | 555     | 06/04/2022 00:00:00 | 1001  |
| 65432    | 666     | 06/05/2022 00:00:00 | 1002  |

**Answer:**

```sql
SELECT 100.0 * (CAST(total_clicks AS FLOAT) / total_views) AS click_through_rate
FROM (
        SELECT COUNT(*) AS total_views 
        FROM   ad_views) v,
    (
        SELECT COUNT(*) AS total_clicks 
        FROM   ad_clicks) c
```

---

### 5. How do you identify records in one table that aren't in another?

To locate records in one table that are absent from another, you can use a LEFT JOIN and then look for NULL values in the right-side table.

For example, say you exported Palo Alto Networks's CRM (Customer Relationship Management) database, and had a table of sales leads, and a second table of companies.

Here's an example of how a LEFT JOIN query can find all sales leads that are not associated with a company:

```sql
SELECT *
FROM sales_leads
LEFT JOIN companies ON sales_leads.company_id = companies.id
WHERE companies.id IS NULL;
```

This query returns all rows from the `sales_leads` table, along with any matching rows from the `companies` table. If there is no matching row in the `companies` table, NULL values will be returned for all of the right table's columns. The WHERE clause then filters out any rows where the `companies.id` column is NULL, leaving only sales leads that are NOT associated with a company.

---

### 6. Average Selling Price Per Product Category

Palo Alto Networks, being a global cybersecurity leader, offers a variety of products in different categories. The company would like to know the average selling price for each product category over a specific period, for strategic decision making.

Consider the following tables `products` and `sales`. The `products` table has information on product id, name and their respective categories. The `sales` table records each sale with specific details including sales price, product id and date of sale.

**Products Example Input:**

| product_id | product_name         | category            |
|------------|----------------------|----------------------|
| 1          | Firewall A           | Firewall            |
| 2          | Antivirus B          | Antivirus           |
| 3          | Intrusion Prevention C | Intrusion Prevention|
| 4          | Firewall D           | Firewall            |
| 5          | Antivirus E          | Antivirus           |

`sales` **Example Input:** 

| sale_id | product_id | sale_date | sale_price |
|---------|------------|------------|------------|
| 1001    | 1          | 2022-01-01| 2000       |
| 1002    | 2          | 2022-01-10| 1500       |
| 1003    | 3          | 2022-02-15| 3000       |
| 1004    | 4          | 2022-02-20| 2500       |
| 1005    | 5          | 2022-03-01| 1800       |

**Example Output:**

| category            | average_sale_price |
|----------------------|-------------------|
| Firewall            | 2250              |
| Antivirus           | 1650              |
| Intrusion Prevention| 3000              |

**Answer:**

```sql
SELECT   category, AVG(sale_price) as avg_sale_price
FROM     products p JOIN sales s USING(product_id)
GROUP BY 1
```

---

### 7. Can you explain the meaning of database denormalization?

Denormalization is a technique used to improve the read performance of a database, typically at the expense of some write performance.

By adding redundant copies of data or grouping data together in a way that does not follow normalization rules, denormalization improves the performance and scalability of a database by eliminating costly join operations, which is important for OLAP use cases that are read-heavy and have minimal updates/inserts.

---

### 8. Filter customer records based on email domain

At Palo Alto Networks, different customers can be distinguished based on their email domain. Suppose we are interested in finding all customers from our customer database who have a specific email provider. For example, a recent marketing campaign focused on gmail.com and we want to examine its effectiveness.

For this reason, create a SQL query that filters all customers from our `customers` table who have an email that ends with `@gmail.com`.

`customers` **Example Input:**

| customer_id | name          | email                | signup_date |
|-------------|---------------|-----------------------|-------------|
| 1           | John Doe      | john.doe@gmail.com   | 2018-05-15  |
| 2           | Jane Doe      | jane.doe@yahoo.com   | 2019-06-20  |
| 3           | Mary Johnson  | mary.j@gmail.com     | 2020-02-05  |
| 4           | James Smith   | james.smith@google.com| 2017-11-30  |
| 5           | Adam Edwards  | adam.e@gmail.com     | 2021-08-10  |

**Answer:**

```sql
SELECT * 
FROM   customers 
WHERE  email LIKE '%@gmail.com'
```


---

### 9. Analyzing Customer Order History

As a database administrator at Palo Alto Networks, you have been tasked with analyzing the customer order history. You have two tables at your disposal - `customers` and `order_history`.

Your task is to write a SQL query that joins the two tables to produce a report that summarises the number of orders made by each customer over the past year. More specifically, the result should include each customer's id, name and the total number of orders they made in the past year.

`Customers` **Example Input:**

| customer_id | first_name | last_name |
|-------------|------------|------------|
| 1001        | John       | Doe        |
| 1002        | Jane       | Doe        |
| 1003        | Sandra     | Albert     |

`Order History` **Example Input:**

| order_id | customer_id | order_date |
|----------|-------------|------------|
| 2001     | 1001        | 2021-09-10 |
| 2002     | 1001        | 2021-11-15 |
| 2003     | 1002        | 2022-02-20 |
| 2004     | 1001        | 2022-04-28 |
| 2005     | 1003        | 2022-05-12 |

**Answer:**

```sql
SELECT   c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, COUNT(o.order_id) AS total_orders
FROM     customers c LEFT JOIN order_history o USING(customer_id)
WHERE    o.order_date > CURRENT_DATE - INTERVAL '1 year'
GROUP BY 1, 2
```

---

### 10. Can you explain the purpose of the CHECK constraint and give an example of when you might use it?

The CHECK constraint is used to enforce rules on the data in a specific column. If a row is inserted or updated with data that does not follow the CHECK constraint's rule, the operation will fail.

For example, say you had a database that stores ad campaign data from Palo Alto Networks's Google Analytics account.

Here's what some constraints could look like:

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

In this example, the CHECK constraint ensures that the `budget` and `cost_per_click` columns only accept positive values. Any attempt to insert or update a row with a negative `budget` or `cost_per_click` value would fail due to the CHECK constraint.


---