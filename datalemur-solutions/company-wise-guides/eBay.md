## 11 eBay SQL Interview Questions

### 1. Highest Number of Products

Assume that you are given the table below containing information on various orders made by eBay customers.

**Write a query to obtain the user IDs and number of products purchased by the top 3 customers; these customers must have spent at least $1,000 in total.**

Output the user id and number of products in descending order. To break ties (i.e., if 2 customers both bought 10 products), the user who spent more should take precedence.

`user_transactions` Table:

| Column Name | Type |
|-------------|------|
| transaction_id | integer |
| product_id | integer |
| user_id | integer |
| spend | decimal |

`user_transactions` Example Input:

| transaction_id | product_id | user_id | spend |
|----------------|------------|---------|-------|
| 131432 | 1324 | 128 | 699.78 |
| 131433 | 1313 | 128 | 501.00 |
| 153853 | 2134 | 102 | 1001.20 |
| 247826 | 8476 | 133 | 1051.00 |
| 247265 | 3255 | 133 | 1474.00 |
| 136495 | 3677 | 133 | 247.56 |

Example Output:

| user_id | product_num |
|---------|-------------|
| 133 | 3 |
| 128 | 2 |
| 102 | 1 |

Answer:

```sql
SELECT   user_id, COUNT(product_id) AS product_num 
FROM     user_transactions 
GROUP BY 1
HAVING   SUM(spend) >= 1000 
ORDER BY product_num DESC, SUM(spend) DESC
LIMIT    3
```

---

### 2. Database Design for eBay Listing and Bidding System

The business case here is simulating the eBay listing and bidding system. We'd like to be able to keep track of users, the products they list for sale, and the bids that other users place on these products. Design the tables to model this system and write a SQL query to fetch the highest current bid for each active listing.

Let's start by identifying the tables we'll need:

- users - Information about users.

- listings - Information about the products that are listed for sale.

- bids - Information about the bids made by users on the listed products.

Here are your example tables:

`users` Sample Input:
| user_id | username |
|---------|----------|
| 1 | user1 |
| 2 | user2 |
| 3 | user3 |

`listings` Sample Input:
| listing_id | user_id | product_name | active |
|------------|---------|--------------|--------|
| 1 | 1 | Prod1 | TRUE |
| 2 | 1 | Prod2 | TRUE |
| 3 | 2 | Prod3 | FALSE |
| 4 | 3 | Prod4 | TRUE |

`bids` Sample Input:
| bid_id | listing_id | user_id | amount |
|--------|------------|---------|--------|
| 1 | 1 | 2 | 200 |
| 2 | 1 | 3 | 250 |
| 3 | 2 | 3 | 50 |
| 4 | 3 | 1 | 400 |
| 5 | 4 | 2 | 300 |

Answer:

```sql
SELECT   b.listing_id, l.product_name, MAX(b.amount) AS highest_bid
FROM     bids b JOIN listings l USING(listing_id)
WHERE    l.active
GROUP BY 1, 2
ORDER BY 3 DESC;
```

---

### 3. What is a self-join?

A self-join is a type of join in which a table is joined to itself. To perform a self-join, you need to specify the table name twice in the FROM clause, and give each instance of the table a different alias. You can then join the two instances of the table using a JOIN clause, and use a WHERE clause to specify the relationship between the rows.

Here's an example query to retrieve all pairs of eBay employees who work in the same department:

```sql
SELECT e1.name AS employee1, e2.name AS employee2
FROM   ebay_employees AS e1 JOIN ebay_employees AS e2 ON e1.department_id = e2.department_id
WHERE  e1.id <> e2.id;
```

---

### 4. Filter and Analyze eBay Customer Activity

In eBay's customer database table 'activities', the 'activity_type' column distinguishes between different types of customer activities such as "VIEW", "BID", and "BUY". 

The goal of this question is to filter out the customers who have viewed a product after bidding on it, but have not yet purchased it. 

**Write a query that returns the user_id, product_id and the timestamp of their last "VIEW" activity.**

`activities` Example Input:

| activity_id | user_id | timestamp | product_id | activity_type |
|-------------|---------|-----------|------------|---------------|
| 6171 | 123 | 2022-03-18 10:00:00 | 1001 | "VIEW" |
| 7802 | 123 | 2022-03-18 09:00:00 | 1001 | "BID" |
| 5293 | 362 | 2022-03-19 14:00:00 | 1002 | "BUY" |
| 6352 | 123 | 2022-03-19 11:00:00 | 1001 | "VIEW" |
| 4517 | 123 | 2022-03-17 00:00:00 | 1001 | "BID" |

Expected Output:

| user_id | product_id | last_view |
|---------|------------|-----------|
| 123 | 1001 | 2022-03-19 11:00:00 |

Answer:
```sql
SELECT t.user_id, t.product_id, MAX(t.timestamp) AS last_view
FROM (
    SELECT user_id, product_id, timestamp
    FROM   activities
    WHERE  activity_type = 'VIEW'
    AND user_id IN (
        SELECT user_id
        FROM   activities
        WHERE  activity_type = 'BID'
    )
    AND user_id NOT IN (
        SELECT user_id
        FROM   activities
        WHERE  activity_type = 'BUY'
    )
) t
GROUP BY 1, 2
```

---

### 5. What's the purpose of the FOREIGN KEY constraint?

A FOREIGN KEY is a field in a table that references the PRIMARY KEY of another table. It creates a link between the two tables and ensures that the data in the FOREIGN KEY field is valid.

Here's an example of creating tables with a foreign key constraint:

```sql
CREATE TABLE ebay_accounts (
    account_id INTEGER PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    industry VARCHAR(255) NOT NULL
);

CREATE TABLE opportunities (
    opportunity_id INTEGER PRIMARY KEY,
    opportunity_name VARCHAR(255) NOT NULL,
    account_id INTEGER NOT NULL,
    FOREIGN KEY (account_id) REFERENCES ebay_accounts(account_id)
);
```

---

### 6. Average Bidding Price Per Category

Given the tables bids and items, **write a SQL query to calculate the average bidding price for each category of items on eBay.**

`bids` Example Input:

| bid_id | item_id | user_id | bid_price | bid_time |
|--------|---------|---------|-----------|----------|
| 1 | 101 | 123 | 20.00 | 2022-10-01 |
| 2 | 101 | 456 | 25.00 | 2022-10-05 |
| 3 | 102 | 123 | 15.00 | 2022-10-01 |
| 4 | 103 | 789 | 30.00 | 2022-10-03 |
| 5 | 104 | 789 | 40.00 | 2022-10-04 |

`items` Example Input:

| item_id | category | description | start_price | start_time | end_time |
|---------|----------|-------------|-------------|------------|----------|
| 101 | Books | "Harry Potter Book" | 15.00 | 2022-09-30 | 2022-10-07 |
| 102 | Toys | "Lego Set" | 10.00 | 2022-10-01 | 2022-10-08 |
| 103 | Electronics | "Bluetooth Headphones" | 25.00 | 2022-10-02 | 2022-10-09 |
| 104 | Electronics | "Smart TV" | 35.00 | 2022-10-03 | 2022-10-10 |

Answer:

```sql
SELECT   i.category, AVG(b.bid_price) AS average_bid_price
FROM     bids b JOIN items i USING(item_id)
GROUP BY 1
```

---

### 7. Can you describe the difference between a clustered and a non-clustered index?

Here's an example of a clustered index on the transaction_id column of a table of eBay payments table:

```sql
CREATE CLUSTERED INDEX transaction_id_index
ON ebay_payments (transaction_id);
```

Here is an example of a non-clustered index on the transaction_id column of the same table:

```sql
CREATE INDEX transaction_id_index
ON ebay_payments (transaction_id);
```

This will create a non-clustered index on the transaction_id column, which will not affect the physical order of the data rows in the ebay_payments table.

In terms of query performance, a clustered index is usually faster for searches that return a large number of records, while a non-clustered index is faster for searches that return a small number of records. 

However, updates to a clustered index are slower, as they require the data rows to be physically rearranged, while updates to a non-clustered index are faster, as they only require the index data structure to be updated.

---

### 8. Determining the Click-Through Conversion Rate for eBay

You're a data analyst at eBay and are tasked to calculate the click-through-conversion rate for the previous month. 

Click-through conversion rate is defined as the number of users that viewed a product and then added that product to their cart, divided by the total number of users that viewed the product.

`product_views` Input:

| user_id | product_id | view_date |
|---------|------------|-----------|
| 101 | 1101 | 06/18/2022 00:00:00 |
| 102 | 1102 | 06/18/2022 00:00:00 |
| 103 | 1101 | 06/19/2022 00:00:00 |
| 101 | 1101 | 06/19/2022 00:00:00 |
| 104 | 1103 | 07/22/2022 00:00:00 |

`add_to_cart` Input:

| user_id | product_id | add_date |
|---------|------------|----------|
| 101 | 1101 | 06/18/2022 00:00:00 |
| 103 | 1101 | 06/19/2022 00:00:00 |
| 101 | 1101 | 06/19/2022 00:00:00 |
| 104 | 1103 | 07/23/2022 00:00:00 |

Answer:

```sql
SELECT pv.product_id, 
       (CAST(num_converted_users AS DECIMAL) / num_total_users) AS conversion_rate
FROM
    (SELECT product_id, COUNT(DISTINCT user_id) as num_total_users
     FROM product_views
     WHERE DATE_PART('month', view_date) = DATE_PART('month', CURRENT_DATE) - 1
     GROUP BY product_id) pv
LEFT JOIN
    (SELECT product_id, COUNT(DISTINCT user_id) as num_converted_users
     FROM add_to_cart
     WHERE DATE_PART('month', add_date) = DATE_PART('month', CURRENT_DATE) - 1
     GROUP BY product_id) atc
ON pv.product_id = atc.product_id;
```

---

### 9. Retrieving eBay Seller Information

As a part of the eBay data team, you are often asked to retrieve specific information from seller records. You are required to retrieve all the sellers from the city of 'San Francisco' and their sales records whose name starts with the letter 'A' or 'B'.

`sellers` Example Input:

| seller_id | seller_name | city |
|-----------|-------------|------|
| 2001 | Amy | San Francisco |
| 4566 | Benny | San Francisco |
| 3167 | Charlie | Los Angeles |
| 9248 | Andy | Los Angeles |
| 8243 | Betty | San Francisco |

`sales` Example Input:

| sale_id | seller_id | sale_date | amount |
|---------|-----------|-----------|--------|
| 1022 | 2001 | 02/01/2022 | 120 |
| 3485 | 4566 | 02/01/2022 | 115 |
| 4761 | 3167 | 02/01/2022 | 180 |
| 9271 | 9248 | 02/01/2022 | 130 |
| 8251 | 8243 | 02/01/2022 | 110 |

Answer:

```sql
SELECT s.seller_name, se.sale_date, se.amount 
FROM   sellers s JOIN sales se ON USING(seller_id)
WHERE  s.city = 'San Francisco' AND (s.seller_name LIKE 'A%' OR s.seller_name LIKE 'B%')
```

---

### 10. Give a few ways in SQL that you can identify duplicate records in a table?

One way to find duplicates is to use a GROUP BY clause and then use HAVING to find groups:

```sql
SELECT   column_name, COUNT(*) as dup_count
FROM     table_name
GROUP BY 1
HAVING   dup_count > 1;
```

You could also use the EXISTS operator:

```sql
SELECT *
FROM   table_name t1
WHERE  EXISTS (
            SELECT 1 
            FROM   table_name t2 
            WHERE  t1.column_name = t2.column_name AND t1.id <> t2.id
        );
```

---

### 11. Find Total Sales and Average Sale Value Per Product

For this question, let's consider that eBay wants to find the total number of sales and the average sale value for each product. You will have to use both the Sales and Products tables for this analysis.

`Sales` Example Input:

| sale_id | product_id | user_id | sale_date | sale_value |
|---------|------------|---------|-----------|------------|
| 1001 | 781 | 101 | 2022-01-06 | 120.0 |
| 1002 | 910 | 202 | 2022-02-26 | 80.0 |
| 1003 | 543 | 303 | 2022-03-08 | 250.0 |
| 1004 | 781 | 101 | 2022-04-16 | 140.0 |
| 1005 | 910 | 303 | 2022-05-28 | 95.0 |

`Products` Example Input:

| product_id | product_name | supplier_id |
|------------|--------------|-------------|
| 781 | Laptop | 5401 |
| 910 | Mobile Phone | 5402 |
| 543 | Television | 5403 |

Answer:

```sql
SELECT   p.product_name, 
         COUNT(s.sale_id) as total_sales, 
         AVG(s.sale_value) as avg_sale_value
FROM     Sales s JOIN Products p USING(product_id)
WHERE    s.sale_value IS NOT NULL
GROUP BY 1
```