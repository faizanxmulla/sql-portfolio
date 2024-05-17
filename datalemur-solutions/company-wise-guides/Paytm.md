## 11 Paytm SQL Interview Questions

### 1. Get Monthly Average Purchase Amount per User

For Paytm, an online transaction platform, it is important to understand the user behavior such as their spending patterns. 

Let's assume that Paytm wants to compute the monthly average purchase amount per user. Here, a SQL window function could be useful.

**Write a SQL query to retrieve the monthly average purchase amount for each user from the Paytm transactions dataset.**

`transactions` **Example Input:**

| transaction_id | user_id | transaction_date | amount |
|----------------|---------|-------------------|--------|
| 6171           | 123     | 06-08-2022        | 500    |
| 7802           | 265     | 06-10-2022        | 200    |
| 5293           | 362     | 06-18-2022        | 300    |
| 6352           | 192     | 07-26-2022        | 500    |
| 4517           | 981     | 07-05-2022        | 400    |

**Example Output:**

| month | user_id | avg_amount |
|-------|---------|------------|
| 6     | 123     | 500.00     |
| 6     | 265     | 200.00     |
| 6     | 362     | 300.00     |
| 7     | 192     | 500.00     |
| 7     | 981     | 400.00     |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM transaction_date) as month, 
         user_id, 
         AVG(amount) as avg_amount
FROM     transactions
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 2. Paytm Transaction Analysis

Given a payment transaction database, how would you devise a query to find how much revenue Paytm made in a particular month from the commission on transactions? Assume Paytm takes 2% commission on each transaction.

Consider the following tables for this problem:

`transactions` **Example Input:**

| **transaction_id** | **user_id** | **transaction_date** | **amount** |
|:-------------------|:------------|:----------------------|:------------|
| 123456             | 1001        | 06/15/2022 09:15:32  | 150.00     |
| 123457             | 1002        | 06/20/2022 10:20:11  | 200.00     |
| 123458             | 1003        | 07/10/2022 16:45:02  | 500.00     |
| 123459             | 1004        | 07/18/2022 13:12:36  | 250.00     |
| 123460             | 1005        | 07/18/2022 18:20:52  | 200.00     |

**Note:** All dates should be formatted as 'MM/DD/YYYY HH:MI:SS', and amounts should be in rupees.

To answer this question, you would need to sum the total transaction amounts for the specified month, multiplied by 0.02 (representing the 2% commission).

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM transaction_date) AS month,
         SUM(amount * 0.02) AS revenue
FROM     transactions
WHERE    EXTRACT(MONTH FROM transaction_date) = {ENTER_DESIRED_MONTH}
GROUP BY 1
```


---

### 3. How does HAVING and WHERE differ?

The HAVING clause serves as a filter for the groups created by the GROUP BY clause, similar to how the WHERE clause filters rows. However, HAVING is applied to groups rather than individual rows.

For example, say you were a data analyst at Paytm trying to understand how sales differed by region:

```sql
SELECT   region, SUM(sales)
FROM     paytm_sales
WHERE    date > '2023-01-01'
GROUP BY 1
HAVING   SUM(sales) > 400000;
```

This query retrieves the total sales for all products in each region, and uses the WHERE clause to only sales made after January 1, 2023. 

The rows are then grouped by region and the HAVING clause filters the groups to include only those with total sales greater than $400,000.

---

### 4. Filter Paytm Customer Transactions

Imagine you are working as a data analyst at Paytm. Your task is to filter down the customer transaction data based on multiple boolean conditions. 

You need to find all transactions that were done during the month of March and April, for total transaction amounts greater than 500. Also, separate the transactions that were successful from the ones that failed.

`transactions` **Example Input**

| transaction_id | customer_id | transaction_date | transaction_amount | transaction_status |
|----------------|-------------|-------------------|--------------------|--------------------|
| 101            | 286         | 03/15/2022        | 600                | Success            |
| 102            | 551         | 04/20/2022        | 800                | Failed             |
| 103            | 917         | 04/08/2022        | 300                | Success            |
| 104            | 286         | 02/25/2022        | 700                | Success            |
| 105            | 442         | 03/31/2022        | 1000               | Failed             |

**Example Output:**

| month | transaction_status | transaction_id |
|-------|---------------------|----------------|
| March | Success             | 101            |
| April | Failed              | 102            |
| March | Failed              | 105            |

**Answer:**

```sql
SELECT EXTRACT(MONTH FROM transaction_date) as month,
       transaction_status,
       transaction_id
FROM   transactions
WHERE  EXTRACT(MONTH FROM transaction_date) IN (3, 4) AND
       transaction_amount > 500;
```


---

### 5. Do UNION ALL and a FULL OUTER JOIN typically produce equivalent results?

No, in almost all cases, and for all practical purposes, UNION ALL and FULL OUTER JOIN do NOT produce the same result.

While both are similar, in that they combine two tables, you can think of joins as increasing the width of the resulting table (you'll have more columns in the result set for a left / inner / right join), whereas a union is used to combine rows which increases the height of the result set but keeps the column count the same.

---

### 6. Average transaction amount per user in Paytm

In the Paytm app, each user has an account and can make several transactions such as bill payments, recharges, ticket bookings, etc. 

As a data analyst, your task is to **find the average transaction amount per user**. Can you write a SQL query to calculate this?


`transactions` **Example Input:**

| transaction_id | user_id | transaction_date | transaction_amount |
|----------------|---------|-------------------|--------------------| 
| 1001           | 1       | 2022-10-05        | 500                |
| 1002           | 2       | 2022-10-05        | 150                |
| 1003           | 1       | 2022-10-06        | 200                |
| 1004           | 3       | 2022-10-07        | 100                |
| 1005           | 1       | 2022-10-08        | 300                |
| 1006           | 2       | 2022-10-08        | 200                |

**Answer:**


```sql
SELECT   user_id, AVG(transaction_amount) AS avg_transaction_amount
FROM     transactions
GROUP BY 1
```


---


### 7. What are SQL constraints, and can you give some examples?

Constraints are used to specify the rules concerning data in the table. It can be applied for single or multiple fields in an SQL table during the creation of the table or after creating using the ALTER TABLE command. The constraints are:

- PRIMARY KEY constraint

- FOREIGN KEY constraint  
- NOT NULL constraint
- UNIQUE constraint
- CHECK constraint
- DEFAULT constraint

Say you were storing sales analytyics data from Paytm's CRM inside a database. Here's some example constraints you could use:

**PRIMARY KEY constraint:** You might use a PRIMARY KEY constraint to ensure that each record in the database has a unique identifier. For example, you could use the "opportunity_id" field as the primary key in the "opportunities" table.

**FOREIGN KEY constraint:** You might use a FOREIGN KEY constraint to link the data in one table to the data in another table. For example, you could use a foreign key field in the "opportunities" table to reference the "account_id" field in the "accounts" table.

**NOT NULL constraint:** You might use a NOT NULL constraint to ensure that a field cannot contain a NULL value. For example, you could use a NOT NULL constraint on the "opportunity_name" field in the "opportunities" table to ensure that each opportunity has a name.

**UNIQUE constraint:** You might use a UNIQUE constraint to ensure that the data in a field is unique across the entire table. For example, you could use a UNIQUE constraint on the "email" field in the "contacts" table to ensure that each contact has a unique email address.

**CHECK constraint:** You might use a CHECK constraint to ensure that the data in a field meets certain conditions. For example, you could use a CHECK constraint to ensure that the "deal_probability" field in the "opportunities" table is a value between 0 and 100.

**DEFAULT constraint:** You might use a DEFAULT constraint to specify a default value for a field. For example, you could use a DEFAULT constraint on the "stage" field in the "opportunities" table to set the default value to "prospecting"

---


### 8. Determining Click-Through Conversion Rate for Paytm

Paytm is an Indian multinational technology company that specializes in e-commerce, digital payment system and financial services. A key analysis for such companies is determining the click-through conversion rate, which measures the success of their digital ads and product placements.

Here's a scenario:

Paytm recently ran digital ads for their new product. Each time a user clicks on an ad, it takes them to the product page on the Paytm website. 

The data science team at Paytm wants to know the conversion rate, i.e., the proportion of users who add the product to their cart after viewing it from the ad click.

Consider you have `two` tables. 

The `ad_clicks` table records each time a user clicks on the ad, and the `add_to_cart` table records each time a user adds the item to their cart.

`ad_clicks` **Example Input:**

| ad_click_id | user_id | click_date        |
|-------------|---------|-------------------|
| 1           | 123     | 06/08/2022 00:00:00 |
| 2           | 265     | 06/10/2022 00:00:00 |
| 3           | 362     | 06/18/2022 00:00:00 |
| 4           | 192     | 06/26/2022 00:00:00 |
| 5           | 981     | 07/05/2022 00:00:00 |

`add_to_cart` **Example Input:**

| cart_id | user_id | cart_date         |
|---------|---------|-------------------|
| 201     | 123     | 06/08/2022 00:10:00 |
| 202     | 265     | 06/10/2022 01:00:00 |
| 203     | 362     | 06/18/2022 02:00:00 |
| 204     | 261     | 07/01/2022 00:00:00 |

Using this data, **write a SQL query to calculate the click-through conversion rate for this product**. 

The rate should be calculated as the number of unique users who added the product to their cart, divided by the number of unique users who clicked the ad, expressed as a percentage.

**Answer:**

```sql
SELECT CAST(COUNT(DISTINCT b.user_id) AS FLOAT) / COUNT(DISTINCT a.user_id) * 100 AS conversion_rate
FROM   ad_clicks a LEFT JOIN add_to_cart b ON a.user_id = b.user_id AND 
                                              a.click_date <= b.cart_date;
```


---

### 9. Calculate the Total Transactions Amount for Each User

Paytm is a digital payment platform that lets users transfer money into the integrated wallet via online transactions such as debit, credit, and net banking. 

Therefore, a good question might be related to understanding user behavior regarding the total transactions amount for each user. 

You are tasked to find the **total transaction amount each user has made**.

`transactions` **Example Input:**

| transaction_id | user_id | transaction_date | amount |
|----------------|---------|-------------------|--------|
| 101            | 123     | 2022-06-01        | 200    |
| 102            | 265     | 2022-06-05        | 500    |
| 103            | 123     | 2022-06-03        | 400    |
| 104            | 123     | 2022-07-01        | 100    |
| 105            | 265     | 2022-07-04        | 200    |
| 106            | 986     | 2022-07-09        | 300    |


The table `transactions` keeps records of all transactions conducted within Paytm. 

Here, `transaction_id` changes with every new transaction, `user_id` refers to the person who made the transaction, and `amount` refers to the total amount in the transaction.


**Example Output:**

| user_id | total_amount |
|---------|--------------|
| 123     | 700          |
| 265     | 700          |
| 986     | 300          |



**Answer:**

```sql
SELECT   user_id, SUM(amount) as total_amount
FROM     transactions
GROUP BY 1
```

---

### 10. What's the main difference between 'BETWEEN' and 'IN' operators?

The BETWEEN and IN operators are both used to filter data based on certain criteria, but they work in different ways. BETWEEN is used to select values within a range, while IN is used to select values that match a list.

For instance, if you have a table called paytm_employees that contains the salary of each employee, along with which country they reside in, you could use the BETWEEN operator to find all employees who make between 130k and 160k:

```sql
SELECT * 
FROM   paytm_employees 
WHERE  salary BETWEEN 130000 AND 160000;
```

To find all employees that reside in France and Germany, you could use the IN operator:

```sql  
SELECT *
FROM   paytm_employees
WHERE  country IN ("France", "Germany");
```

---


### 11. Analysis of Customer Transactions

We have two tables: customer_details which provides personal data of customers and transaction_details which gives information about transactions made by those customers.

Our objective is to get the list of customers who have made transactions above a certain limit (let's say 500) and also get their personal details from the customer_details table. We will use the customer_id field to JOIN the two tables.

We are looking to produce a summary table which contains the customer_ID, customer_name, transaction_ID, and the transaction_amount of transactions that have more than $500.

Here are the tables:

`customer_details` **Example Input:**

| customer_id | customer_name | customer_email     | contact_number |
|-------------|----------------|--------------------|-----------------| 
| 1           | John Doe       | john.doe@email.com | 0123456789     |
| 2           | Jane Doe       | jane.doe@email.com | 9876543210     |
| 3           | Sam Smith      | sam.smith@email.com| 1122334455     |

`transaction_details` **Example Input:**

| transaction_id | customer_id | transaction_date  | transaction_amount |
|-----------------|-------------|-------------------|--------------------|
| 111             | 1           | 06/08/2022 00:00:00 | 400              |
| 222             | 1           | 06/10/2022 00:00:00 | 1000             |
| 333             | 2           | 06/18/2022 00:00:00 | 600              |
| 444             | 3           | 07/26/2022 00:00:00 | 200              |  
| 555             | 3           | 07/05/2022 00:00:00 | 800              |

**Answer:**

```sql
SELECT c.customer_id, c.customer_name, t.transaction_id, t.transaction_amount
FROM   customer_details c JOIN transaction_details t USING(customer_id)
WHERE  t.transaction_amount > 500;
```


---