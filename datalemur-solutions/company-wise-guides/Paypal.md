## 11 Paypal SQL Interview Questions

### 1. Final Account Balance

Given a table containing information about bank deposits and withdrawals made using Paypal, write a query to retrieve the final account balance for each account, taking into account all the transactions recorded in the table with the assumption that there are no missing transactions.

**transactions Table:**

| Column Name | Type |
|-------------|------|
| transaction_id | integer |
| account_id | integer |
| amount | decimal |
| transaction_type | varchar |

**transactions Example Input:**

| transaction_id | account_id | amount | transaction_type |
|----------------|------------|--------|------------------|
| 123 | 101 | 10.00 | Deposit |
| 124 | 101 | 20.00 | Deposit |
| 125 | 101 | 5.00 | Withdrawal |
| 126 | 201 | 20.00 | Deposit |
| 128 | 201 | 10.00 | Withdrawal |

**Example Output:**

| account_id | final_balance |
|------------|---------------|
| 101 | 25.00 |
| 201 | 10.00 |

Using account ID 101 as an example, $30.00 was deposited into this account, while $5.00 was withdrawn. Therefore, the final account balance can be calculated as the difference between the total deposits and withdrawals which is $30.00 - $5.00, resulting in a final balance of $25.00.

**Answer:**

```sql
SELECT   account_id,
         CASE 
            WHEN transaction_type = 'Deposit' THEN amount
            ELSE -amount 
         END AS final_balance
FROM     transactions
GROUP BY 1
```

---

### 2. Calculate the Average Transaction Amount per User

As a data scientist at PayPal, you have been asked to write a SQL query to analyze the transaction history of PayPal users. Specifically, management wants to know the average transaction amount for each user, and how they rank based on their averages. For this task:

- Calculate the average transaction amount for every user

- Rank the users by their average transaction amount in descending order

Note: When the same average transaction amount is found for multiple users, they should have the same rank. And the user with the next higher average transaction amount should be given the rank number which comes after the consecutive rank.

**transactions Example Input:**

| transaction_id | user_id | transaction_date | amount |
|----------------|---------|------------------|--------|
| 1 | 1000 | 01/25/2021 | 50 |
| 2 | 1000 | 03/02/2021 | 150 |
| 3 | 2000 | 03/04/2021 | 300 |
| 4 | 3000 | 04/15/2021 | 100 |
| 5 | 2000 | 04/18/2021 | 200 |
| 6 | 3000 | 05/05/2021 | 100 |
| 7 | 4000 | 05/10/2021 | 500 |

**Answer:**

```sql
WITH user_average AS (
    SELECT user_id, AVG(amount) OVER(PARTITION BY user_id) as avg_transaction
    FROM   transactions
)
SELECT   user_id, 
         avg_transaction, 
         RANK() OVER(ORDER BY avg_transaction DESC) as rank
FROM     user_average
ORDER BY rank
```

---

### 3. How do the RANK() and DENSE_RANK() window functions differ from each other?

While both RANK() and DENSE_RANK() are used to rank rows, the key difference is in how they deal with ties.

**RANK()**: When there's a tie, RANK() leaves a gap in the ranking. For example, if three rows are tied for 2nd place, the RANK() function will assign a rank of 2 to the first of these rows, a rank of 3 to the 2nd row in the tie, and a rank of 4 to the the 3rd tie.

**DENSE_RANK()**: For ties, DENSE_RANK() does not leave a gap in the ranking. Instead, it assigns the same rank to all tied rows, and then makes the next row 1 bigger. Confusing, I know, but here's an example to make it more clear: if three rows are tied for 3rd place, the DENSE_RANK() function will assign a rank of 3 to all three rows, and then assign a rank of 4 to the next row.

Suppose we had data on how many deals different salespeople at PayPal:

```sql
WITH data AS (
  SELECT 'Akash' AS name, 50 AS deals_closed UNION ALL
  SELECT 'Brittany', 50 UNION ALL
  SELECT 'Carlos', 40 UNION ALL
  SELECT 'Dave', 30 UNION ALL
  SELECT 'Eve', 30 UNION ALL
  SELECT 'Farhad', 10
)

SELECT name, deals_closed,
  RANK() OVER (ORDER BY deals_closed DESC) as rank,
  DENSE_RANK() OVER (ORDER BY deals_closed DESC) as dense_rank
FROM paypal_sales;
```

The result of this query would be:

| name | deals_closed | rank | dense_rank |
|------|--------------|------|------------|
| Akash | 50 | 1 | 1 |
| Brittany | 50 | 2 | 1 |
| Carlos | 40 | 3 | 2 |
| Dave | 40 | 4 | 3 |
| Eve | 30 | 5 | 3 |
| Farhad | 10 | 6 | 4 |

---

### 4. Determining High-Value Customers

Suppose you are a data analyst at PayPal, and you have been asked to create a report that identifies all users who have sent payments of more than 1000 or have received payments of more than 5000 in the last month. 

We want to filter out any user whose account is flagged as "fraudulent".

**Transactions** Example Input:

| transaction_id | user_id | transaction_date | transaction_type | amount |
|----------------|---------|------------------|------------------|--------|
| 101 | 123 | 07/08/2022 00:00:00 | Sent | 750 |
| 102 | 265 | 07/10/2022 00:00:00 | Received | 6000 |
| 103 | 265 | 07/18/2022 00:00:00 | Sent | 1500 |
| 104 | 362 | 07/26/2022 00:00:00 | Received | 6000 |
| 105 | 981 | 07/05/2022 00:00:00 | Sent | 3000 |

**User** Example Input:

| user_id | username | is_fraudulent |
|---------|----------|---------------|
| 123 | Jessica | false |
| 265 | Daniel | true |
| 362 | Michael | false |
| 981 | Sophia | false |

**Expected Output:**

| user_id | username |
|---------|----------|
| 362 | Michael |
| 981 | Sophia |

**Answer:**

```sql
SELECT   u.user_id, u.username
FROM     Transactions t JOIN User u USING(user_id)
WHERE    t.transaction_date > (CURRENT_DATE - INTERVAL '1 month') AND 
         ((t.transaction_type = 'Sent' AND t.amount > 1000) OR 
         (t.transaction_type = 'Received' AND t.amount > 5000)) AND 
         u.is_fraudulent = false
GROUP BY 1, 2
```

---

### 5. What is database denormalization, and when is it a good idea to consider it?

Denormalization is like the puzzle-solving equivalent of taking a shortcut!

Instead of putting all the pieces in separate piles, you might decide to clone some of the pieces, and then have that one puzzle piece be put into multiple piles. Clearly, we are breaking the rules of physics, but that's just like de-normalization because it breaks the normal rules of normalization (1st, 2nd, 3rd normal forms).

By adding redundant puzzle pieces, it can be easier to find the pieces you need, but it also means that you have to be extra careful when you're moving pieces around or adding new ones (aka INSERT/UPDATE commands become more complex).

On the plus side, denormalization can improve the performance of your database and make it easier to use. On the downside, it can make your database more prone to errors and inconsistencies, and it can be harder to update and maintain. In short, denormalization can be a helpful tool, but it's important to use it wisely!


---

### 6. Calculate Click-Through Conversion Rate For PayPal

Given a hypothetical situation where PayPal runs several online marketing campaigns, they want to closely monitor the click-through conversion rate of their campaigns for optimization. 

The click-through conversion rate is the number of users who click on the advertisement and proceed to add a product (in this case, setting up a new PayPal account) divided by the total number of users who have clicked the ad.

**ad_clicks** Example Input:

| click_id | user_id | click_time | ad_id |
|----------|---------|------------|-------|
| 1 | 200 | 2022-09-01 10:14:00 | 4001 |
| 2 | 534 | 2022-09-01 11:30:00 | 4003 |
| 3 | 120 | 2022-09-02 14:43:00 | 4001 |
| 4 | 534 | 2022-09-03 16:15:00 | 4002 |
| 5 | 287 | 2022-09-04 17:20:00 | 4001 |

**account_setup** Example Input:

| setup_id | user_id | setup_time |
|----------|---------|------------|
| 1 | 200 | 2022-09-01 10:30:00 |
| 2 | 287 | 2022-09-04 17:40:00 |
| 3 | 534 | 2022-09-01 11:45:00 |

**Answer:**

```sql
SELECT   DATE(ac.click_time) AS day,
         COUNT(DISTINCT ac.user_id) AS total_clicks,
         COUNT(DISTINCT as.user_id) AS total_setups,
         COUNT(DISTINCT as.user_id)::float / COUNT(DISTINCT ac.user_id) AS click_through_conversion_rate
FROM     ad_clicks AS ac LEFT JOIN account_setup AS as ON ac.user_id = as.user_id 
WHERE    DATE(ac.click_time) BETWEEN '2022-09-01' AND '2022-09-07'
GROUP BY DATE(ac.click_time)
ORDER BY 1
```

---

### 7. Can you describe the role of the CHECK constraint and provide an example of a situation where it might be applied?

The CHECK constraint is used to specify a condition that the data in a column must meet. If a row is inserted or updated and the data in the column doesn't meet the condition specified by the CHECK constraint, the operation will sadly fail.

For example, you might use a CHECK constraint to ensure that a column contains only positive numbers, or that a date is within a certain range.

For example, if you had a table of PayPal employees, here's an example of how to use the CHECK constraint in a CREATE TABLE statement:

```sql
CREATE TABLE paypal_employees (
  id INT PRIMARY KEY,
  salary INT CHECK (salary > 0),
  hire_date DATE CHECK (hire_date >= '1970-01-01')
);
```

---

### 8. Identify the Highest Revenue-Generating Products of PayPal

As a data analyst at PayPal, your task is to identify the products which generate the highest total revenue for each month. 

Assume that each transaction on PayPal relates to a product purchased, and the revenue generated is the transaction amount. Each transaction is timestamped, and the product ID is also recorded.

**transactions** Example Input:

| transaction_id | user_id | transaction_date | product_id | transaction_amount |
|----------------|---------|------------------|------------|---------------------|
| 218 | 123 | 06/08/2022 00:00:00 | 50001 | 150.00 |
| 320 | 265 | 06/12/2022 00:00:00 | 69852 | 200.00 |
| 475 | 362 | 06/21/2022 00:00:00 | 50001 | 300.00 |
| 650 | 192 | 07/06/2022 00:00:00 | 69852 | 100.00 |
| 789 | 981 | 07/05/2022 00:00:00 | 69852 | 250.00 |

**Example Output:**

| month | product | total_revenue |
|-------|---------|---------------|
| 6 | 50001 | 450.00 |
| 6 | 69852 | 200.00 |
| 7 | 69852 | 350.00 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM transaction_date) AS month, 
         product_id AS product, 
         SUM(transaction_amount) AS total_revenue
FROM     transactions
GROUP BY 1, 2
ORDER BY 3 DESC;
```

---

### 9. Filter PayPal Customer Records Based on Email Domain

As a PayPal data analyst, you are tasked with identifying user profiles that were created with corporate email addresses, specifically those that end with '@paypal.com'.

**customer** Example Input:

| customer_id | first_name | last_name | email | create_date |
|-------------|------------|-----------|-------|-------------|
| 1 | John | Doe | johndoe@gmail.com | 2022-01-01 |
| 2 | Jane | Smith | janesmith@paypal.com | 2022-02-01 |
| 3 | Max | Lee | maxlee@yahoo.com | 2022-02-01 |
| 4 | Abby | Chen | abbychen@paypal.com | 2022-03-01 |

**Example Output:**

| customer_id | first_name | last_name | email | create_date |
|-------------|------------|-----------|-------|-------------|
| 2 | Jane | Smith | janesmith@paypal.com | 2022-02-01 |
| 4 | Abby | Chen | abbychen@paypal.com | 2022-03-01 |

**Answer:**

```sql
SELECT *
FROM   customer
WHERE  email LIKE '%@paypal.com';
```

---

### 10. What is the purpose of the SQL constraint UNIQUE?

The UNIQUE constraint makes sure that all values in a column are distinct. It is often paired with other constraints, like NOT NULL, to ensure that the data follows certain rules.

For example, say you were an analyst on the marketing team at PayPal, and had access to a database on marketing campaigns:

```sql
CREATE TABLE paypal_campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget DECIMAL(10,2) NOT NULL
);
```

In this example, the UNIQUE constraint is applied to the "campaign_name" field to ensure that each campaign has a unique name. This helps to ensure the integrity of the data in the paypal_campaigns table and prevents errors that could occur if two campaigns had the same name.

---

### 11. Analyzing User Transaction Data

You're given two tables - "Users" and "Transactions". 

- The "Users" table records PayPal's user base. Each row represents a different user, and includes fields for the user_id and signup_date. 

- The "Transactions" table records transactions made by these users. Each row represents a different transaction and includes fields for transaction_id, user_id, transaction_date and transaction_amount.

**Write a SQL query that calculates the total and average transaction amount for all transactions for each user.** 

Include only users who have made at least two transactions.

**Users** Example Input:

| user_id | signup_date |
|---------|-------------|
| 1 | 2020-01-30 |
| 2 | 2020-02-15 |
| 3 | 2020-03-20 |
| 4 | 2020-04-01 |

**Transactions** Example Input:

| transaction_id | user_id | transaction_date | transaction_amount |
|----------------|---------|------------------|---------------------|
| 101 | 1 | 2020-02-01 | 50.00 |
| 102 | 1 | 2020-02-02 | 100.00 |
| 103 | 2 | 2020-02-20 | 200.00 |
| 104 | 2 | 2020-02-25 | 500.00 |
| 105 | 3 | 2020-03-25 | 100.00 |
| 106 | 4 | 2020-05-05 | 300.00 |

**Expected Output:**

| user_id | total_amount | average_amount |
|---------|--------------|-----------------|
| 1 | 150.00 | 75.00 |
| 2 | 700.00 | 350.00 |

**Answer:**

```sql
SELECT   t.user_id,
         SUM(t.transaction_amount) AS total_amount,
         AVG(t.transaction_amount) AS average_amount
FROM     Transactions t
GROUP BY 1
HAVING   COUNT(t.transaction_id) >= 2;
```

---