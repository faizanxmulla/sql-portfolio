## 9 Salesforce SQL Interview Questions

### 1. Calculate the Rolling Average Sales of Each Product

As a data analyst at Salesforce, your task is to analyze the sales data and calculate the rolling 3-month average sales of each product. 

Given the sales data table, **write a SQL query to calculate the rolling 3-month average sales for each product**. 

The rolling average should calculate the current month and the previous 2 months. If there is not enough data for three months, take the average of what is available.

`sales` **Example Input:**

| sales_id | product_id | date       | quantity |
|----------|------------|------------|----------|
| 101      | 435        | 01/25/2022 | 10       |
| 102      | 435        | 02/15/2022 | 15       |
| 103      | 435        | 03/10/2022 | 20       |
| 104      | 436        | 01/30/2022 | 8        |
| 105      | 436        | 03/20/2022 | 12       |
| 106      | 437        | 02/05/2022 | 7        |
| 107      | 437        | 03/25/2022 | 14       |
| 108      | 437        | 04/15/2022 | 17       |

**Example Output:**

| product_id | date       | average_quantity |
|------------|------------|------------------|
| 435        | 01/25/2022 | 10.00            |
| 435        | 02/15/2022 | 12.50            |
| 435        | 03/10/2022 | 15.00            |
| 436        | 01/30/2022 | 8.00             |
| 436        | 03/20/2022 | 10.00            |
| 437        | 02/05/2022 | 7.00             |
| 437        | 03/25/2022 | 10.50            |
| 437        | 04/15/2022 | 12.67            |

**Answer:**

```sql
SELECT   product_id, 
         date, 
         AVG(quantity) OVER (PARTITION BY product_id 
                             ORDER BY date 
                             ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as average_quantity
FROM     sales
ORDER BY 1, 2
```

---

### 2. Filter Customer Records Based on Specific Conditions

Given a database of customer interactions with the Salesforce system, write an SQL query to retrieve all records of customers who have either logged in to the system or made a transaction more than 50 times in the past month, but have not contacted customer support in that time period.

The database has the following two tables:

`customer` **Example Input:**

| customer_id | name          | email                  |
|-------------|---------------|------------------------|
| 101         | John Doe      | johndoe@example.com    |
| 102         | Jane Smith    | janesmith@example.com  |
| 103         | Sarah Johnson | sarahjohnson@example.com |
| 104         | Matthew Taylor| matthewtaylor@example.com|

`customer_activity` **Example Input:**

| activity_id | customer_id | activity_type   | activity_count  | date       |
|-------------|-------------|-----------------|-----------------|------------|
| 1           | 101         | login           | 100             | 2022-07-01 |
| 2           | 102         | transaction     | 30              | 2022-07-02 |
| 3           | 103         | transaction     | 52              | 2022-07-03 |
| 4           | 104         | contact_support | 75              | 2022-07-04 |
| 5           | 103         | login           | 85              | 2022-07-05 |

**Answer:**

```sql
SELECT customer_id, name, email
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM customer_activity ca
    WHERE c.customer_id = ca.customer_id
      AND activity_type IN ('login', 'transaction')
      AND activity_count > 50
      AND date >= CURRENT_DATE - INTERVAL '1 month'
)
AND NOT EXISTS (
    SELECT 1
    FROM customer_activity ca
    WHERE c.customer_id = ca.customer_id
      AND activity_type = 'contact_support'
      AND date >= CURRENT_DATE - INTERVAL '1 month'
)


-- or --

SELECT   c.customer_id, c.name, c.email
FROM     customer c JOIN customer_activity ca USING(customer_id)
WHERE    (ca.activity_type = 'login' OR ca.activity_type = 'transaction')
         AND ca.date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)
GROUP BY 1
HAVING   SUM(CASE WHEN ca.activity_type = 'login' THEN 1 ELSE 0 END) + 
         SUM(CASE WHEN ca.activity_type = 'transaction' THEN 1 ELSE 0 END) > 50 and
         SUM(CASE WHEN ca.activity_type = 'contact_support' THEN 1 ELSE 0 END) = 0;
```

---

### 3. Are the results of a UNION ALL and a FULL OUTER JOIN usually the same?

No, in almost all cases, and for all practical purposes, UNION ALL and FULL OUTER JOIN do NOT produce the same result.

While both are similar, in that they combine two tables, you can think of joins as increasing the width of the resulting table (you'll have more columns in the result set for a left/inner/right join), whereas a union is used to combine rows which increases the height of the result set but keeps the column count the same.

---

### 4. Average Close Time of Tickets in Salesforce

As a customer relationship management solution, Salesforce keeps track of help tickets created by users. For this problem, let's consider you are being asked to find the average number of days it takes to close a ticket.

`tickets` **Example Input:**

| ticket_id | creation_date | close_date  |
|-----------|----------------|-------------|
| 101       | 2022-06-01     | 2022-06-05  |
| 102       | 2022-06-01     | 2022-07-05  |
| 103       | 2022-05-18     | 2022-05-22  |
| 104       | 2022-07-01     | 2022-07-02  |
| 105       | 2022-07-02     | 2022-07-04  |

The dates are in the format `YYYY-MM-DD`.

Here we're considering only tickets that have been closed, which are the ones that have a close_date.

**Write a SQL query that will provide the average close time of tickets on a monthly basis.**

**Example Output:**

| Month | Avg_close_days |
|-------|----------------|
| 5     | 4.0            |
| 6     | 32.0           |
| 7     | 1.5            |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM close_date) as Month, 
         AVG(EXTRACT(DAY FROM (close_date - creation_date))) as Avg_close_days
FROM     tickets
WHERE    close_date IS NOT NULL
GROUP BY 1
ORDER BY 1
```

---

### 5. Can you describe the different types of joins in SQL?

In SQL, a join is used to combine rows from different tables based on a shared key or set of keys, resulting in a single merged table of data.

There are four distinct types of JOINs: INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN.

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
LEFT JOIN Table_B B
ON A.col = B.col;
```

- **RIGHT (OUTER) JOIN**: Retrieves all the records/rows from the right and the matched records/rows from the left table.

```sql
SELECT *
FROM Table_A A
RIGHT JOIN Table_B B
ON A.col = B.col;
```

- **FULL (OUTER) JOIN**: Retrieves all the records where there is a match in either the left or right table.

```sql
SELECT *
FROM Table_A A
FULL JOIN Table_B B
ON A.col = B.col;
```

---

### 6. Analysing Click-through-Rate for Salesforce

Salesforce is interested in understanding the click-through rates of their marketing emails.They want to establish a correlation with a specific user and a product.

They want to know how many users clicked on each email for a specific product, how many viewed the specific product page after clicking on the email, and how many eventually added the product to their cart.

Salesforce keeps track of the following two tables:

`email_clicks` **Example Input:**

| email_id | user_id | click_date          | product_id |
|----------|---------|----------------------|------------|
| 1001     | 332     | 01/01/2023 08:32:00 | 7812       |
| 1002     | 488     | 01/01/2023 09:13:00 | 7812       |
| 1003     | 332     | 01/02/2023 10:45:00 | 7813       |
| 1004     | 488     | 01/02/2023 12:30:00 | 7813       |
| 1005     | 332     | 01/03/2023 08:32:00 | 7812       |

`product_views` **Example Input:**

| view_id | user_id | view_date           | product_id | added_to_cart |
|---------|---------|----------------------|------------|---------------|
| 5001    | 332     | 01/01/2023 08:33:00 | 7812       | Yes           |
| 5002    | 488     | 01/01/2023 09:15:00 | 7812       | No            |
| 5003    | 332     | 01/02/2023 10:50:00 | 7813       | Yes           |
| 5004    | 488     | 01/02/2023 12:33:00 | 7813       | No            |
| 5005    | 332     | 01/03/2023 08:35:00 | 7812       | Yes           |

**Write a query showing the number of emails clicked, number of product page views, and how many products were added to cart for each product.**

**Answer:**

```sql
SELECT   e.product_id,
         COUNT(DISTINCT e.email_id) AS `Number_of_Clicks`,
         COUNT(DISTINCT p.view_id) AS `Number_of_Product_Views`,
         SUM(CASE WHEN p.added_to_cart='Yes' THEN 1 ELSE 0 END) AS `Number_of_Added_to_Cart`
FROM     email_clicks e LEFT JOIN product_views p ON e.user_id = p.user_id AND 
                                                     e.product_id = p.product_id AND
                                                     DATE(e.click_date) = DATE(p.view_date)
GROUP BY 1
```


---

### 7. What's the difference between an inner and a full outer join?

A **full outer join** returns all rows from both tables, including any unmatched rows, whereas an **inner join** only returns rows that match the join condition between the two tables.

For an example of each one, say you had sales data exported from Salesforce's Salesforce CRM stored in a datawarehouse which had two tables: sales and salesforce_customers.

**INNER JOIN**: retrieves rows from both tables where there is a match in the shared key or keys.

```sql
SELECT *
FROM sales
INNER JOIN salesforce_customers
ON sales.customer_id = salesforce_customers.id
```

This query will return rows from the sales and salesforce_customers tables that have matching customer id values. Only rows with matching customer_id values will be included in the results.

**FULL OUTER JOIN**: retrieves all rows from both tables, regardless of whether there is a match in the shared key or keys. If there is no match, NULL values will be returned for the columns of the non-matching table.

Here is an example of a SQL full outer join using the sales and salesforce_customers tables:

```sql
SELECT *
FROM sales
FULL OUTER JOIN salesforce_customers
ON sales.customer_id = salesforce_customers.id
```

---

### 8. Filtering Customer Records with LIKE keyword

As a Salesforce administrator, you are tasked with examining the customer records specifically looking at customers' email addresses. 

The use of Salesforce has recently expanded into Europe and you've noticed a significant uptake from french businesses. 

You need to filter all the customers that have email addresses ending with '.fr', which is a common French domain.

`Users` **Example Input:**

| user_id | full_name      | email                 |
|---------|----------------|------------------------|
| 1001    | Todd Murphy    | todd.murphy@example.fr|
| 1002    | Amanda Shank   | amanda.shank@example.com|
| 1003    | Adria Richards | adria.richards@example.co.uk|
| 1004    | Ellen Connelly | ellen.connelly@example.fr|
| 1005    | Zack Yates     | zack.yates@example.fr |

**Example Output:**

| user_id | full_name      | email                 |
|---------|----------------|------------------------|
| 1001    | Todd Murphy    | todd.murphy@example.fr|
| 1004    | Ellen Connelly | ellen.connelly@example.fr|
| 1005    | Zack Yates     | zack.yates@example.fr |

**Answer:**

```sql
SELECT user_id, full_name, email
FROM   Users
WHERE  email LIKE '%.fr';
```

---


### 9. Calculate Salesperson Performance

Salesforce uses a point system to quantify salesperson performance. A salesperson gets 1 point each time they make a sale, 2 points for each sale they make that is over $1000, and 3 points for each sale they make that is over $5000. 

Write a SQL query to determine the total points for each salespeople and find out the percentage of their points that comes from sales over $1000 and sales over $5000?

`sales` **Example Input:**

| sale_id | sale_date           | salesperson_id | sale_amount |
|---------|----------------------|----------------|-------------|
| 1       | 06/08/2022 00:00:00 | 42             | $1500       |
| 2       | 06/10/2022 00:00:00 | 71             | $6000       |
| 3       | 06/18/2022 00:00:00 | 42             | $700        |
| 4       | 07/26/2022 00:00:00 | 71             | $30000      |
| 5       | 07/05/2022 00:00:00 | 42             | $50         |

**Answer:**

```sql
WITH points_cte as (
    SELECT   salesperson_id,
             SUM(CASE WHEN sale_amount > 1000 THEN 1 ELSE 0 END) AS plus_1000_points,
             SUM(CASE WHEN sale_amount > 5000 THEN 1 ELSE 0 END) AS plus_5000_points,
             SUM(CASE WHEN sale_amount > 1000 THEN 2 
                      WHEN sale_amount > 5000 THEN 3
                    ELSE 1 
                END) AS total_points
    FROM     sales
    GROUP BY 1
)
SELECT total_points, 
	   ROUND(100.0 * plus_1000_points / total_points, 2) as pct_over_1000,
       ROUND(100.0 * plus_5000_points / total_points, 2) as pct_over_5000
FROM   points_cte
```

---