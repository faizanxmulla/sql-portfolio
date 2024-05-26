## 11 IndiaMART SQL Interview Questions

### 1. Identify Top Users On IndiaMART

For the hypothetical company "IndiaMART", assuming they are an online marketplace dealing in various kinds of goods and services, and they value the users who make the most purchases or place the most orders the highest, you are to **write a query to identify the top 10 users with the most orders in the last 30 days**.

For this task, we'll assume there are orders and users tables.


`users` **Example Input:**

| user_id | username |
|---------|----------|
| 1       | User1    |
| 2       | User2    |
| 3       | User3    |
| 4       | User4    |
| 5       | User5    |

`orders` **Example Input:**

| order_id | user_id | order_date | product_id |
|----------|---------|------------|------------|
| 1001     | 1       | 07/16/2022 | 500        |
| 1002     | 2       | 07/12/2022 | 600        |
| 1003     | 1       | 07/10/2022 | 500        |
| 1004     | 3       | 07/11/2022 | 500        |
| 1005     | 5       | 07/08/2022 | 600        |
| 1006     | 2       | 07/15/2022 | 700        |
| 1007     | 1       | 07/12/2022 | 700        |
| 1008     | 4       | 07/13/2022 | 800        |
| 1009     | 5       | 07/08/2022 | 900        |

**Answer:**
Here's a SQL query in PostgreSQL which solves the problem:

```sql
SELECT   u.username, COUNT(o.order_id) as order_count
FROM     users u JOIN orders o USING(user_id)
WHERE    o.order_date > CURRENT_DATE - INTERVAL '30 days'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    10;
```

---

### 2. Calculate the Month Wise Sales and Their Change

Assuming that you are working as a Data Analyst at IndiaMART and your manager has asked you to analyze the current year's monthly sales for each product and calculate the percentage change in sales compared to the previous month. 

This will help the company to find out which products are doing well and which are not performing as per the expectation.

`sales` **Example Input:**

| sale_id | sale_date | product_id | price | quantity |
|---------|------------|------------|-------|----------|
| 101     | 01/06/2022 | 001        | 200   | 10       |
| 102     | 02/07/2022 | 001        | 200   | 15       |
| 103     | 03/06/2022 | 002        | 100   | 20       |
| 104     | 01/06/2022 | 003        | 300   | 10       |
| 105     | 02/07/2022 | 003        | 300   | 5        |
| 106     | 03/08/2022 | 003        | 300   | 8        |

**Answer:**

```sql
WITH month_sales_cte as (
    SELECT   EXTRACT(MONTH FROM sale_date) as month, 
             product_id, 
             SUM(price * quantity) as current_month_sales
    FROM     sales
    GROUP BY 1, 2
    ORDER BY 1, 2
),
prev_month_sales_cte as (
    SELECT *, LAG(current_month_sales) OVER (PARTITION BY product_id ORDER BY month) AS prev_month_sales
    FROM   month_sales_cte
)
SELECT   product_id, 
         month, 
         current_month_sales, 
         prev_month_sales,
   	     CASE 
            WHEN prev_month_sales = 0 THEN NULL
            ELSE ROUND(((current_month_sales - prev_month_sales) / prev_month_sales) * 100, 2)
         END AS percent_sales_change
FROM     prev_month_sales_cte  
ORDER BY 2
```

---

### 3. Can you explain the distinction between a unique and a non-unique index?

While both types of indexes improve the performance of SQL queries by providing a faster way to lookup rows of data, a unique index enforces the uniqueness of the indexed columns while a non-unique index allows duplicate values in the indexed columns.

Suppose you had a table of IndiaMART employees. Here's an example of a unique index on the employee_id column:

```sql
CREATE UNIQUE INDEX employee_id_index
ON indiamart_employees (employee_id);
```

This index would ensure that no two IndiaMART employees have the same employee_id, which could be used as a unique identifier for each employee.

Here's a non-unique index example example on the job_title column:

```sql
CREATE INDEX job_title_index
ON indiamart_employees (job_title);
```

This index would not enforce uniqueness, but it could be used to improve the performance of queries that filter or sort the data based on the job_title column. For example, if you want to quicklly retreive all Data Scientists, the database can use the index to efficiently locate and retrieve the desired records without having to do a full table scan on all IndiaMART employees.

---

### 4. Sales Analysis for Products on IndiaMART

Given the sales data for products on IndiaMART, design tables for Products, Orders, and Order Details, and find out the best-selling product(s) in the last month.

**Assumptions:**

- Products table will hold details about the products.

- Orders table will hold the details about the Orders.

- Order_Details table holds details about which product was ordered in which order.

`products` **Example Input:**

| product_id | supplier_id | product_name  | category        |
|------------|-------------|---------------|-----------------| 
| 12345      | 999         | Water Bottle  | Outdoor Equipment|
| 56789      | 999         | Tent          | Outdoor Equipment|
| 10112      | 777         | Bike Helmet   | Sporting Goods  |
| 13141      | 888         | Running Shoes | Sporting Goods  |

`orders` **Example Input:**

| order_id | customer_id | order_date |
|----------|-------------|------------|
| 50001    | 123         | 06/10/2022 |
| 50002    | 456         | 06/10/2022 |
| 50003    | 789         | 07/05/2022 |
| 50004    | 012         | 07/26/2022 |

`order_details` **Example Input:**

| order_detail_id | order_id | product_id | quantity |
|-----------------|-----------|------------|----------|
| 102030          | 50001    | 12345| 1 |
| 204060          | 50001    | 10112      | 1 |
| 304050          | 50002    | 56789      | 2 |
| 403020          | 50003    | 13141      | 1 |
| 502040          | 50004    | 12345      | 3 |

**Answer:**


```sql
SELECT   p.product_name, COUNT(*) as total_ordered
FROM     order_details od JOIN orders o USING(order_id)
                          JOIN products p USING(product_id)
WHERE    DATE_TRUNC('month', o.order_date) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' month)
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

---

### 5. Can you explain the difference between a foreign and primary key in a database?
A primary key is a column (or set of columns) in a table that uniquely identifies each row in the table. It cannot contain null values and must be unique across all rows in the table.

A foreign key is a column (or set of columns) in a table that references the primary key of another table. It is used to establish a relationship between the two tables. A foreign key can contain null values, and multiple rows in the referencing table can reference the same row in the referenced table.

For example, consider a database with two tables: indiamart_customers and indiamart_orders. The IndiaMART customers table might have a primary key column called customer_id, while the IndiaMART orders table might have a foreign key column called customer_id that references the customer_id column in the indiamart_customers table. This establishes a relationship between the two tables, such that each row in the orders table corresponds to a specific IndiaMART customer.

---

### 6. Calculate Average Purchase Price for Vendors from Different Cities
Suppose you are analyzing vendors from different cities selling on IndiaMART, with data such as vendor_id, city, category, and average_price. 

**Write a SQL query to calculate the average purchase price per product category for vendors in Mumbai or Delhi.**

Assume the relevant table is called vendors.

`vendors` **Example Input:**

| vendor_id | city      | category    | average_price |
|-----------|-----------|-------------|---------------|
| 1         | Mumbai    | Electronics | 5000          |
| 2         | Delhi     | Clothing    | 1500          |
| 3         | Delhi     | Electronics | 8000          |
| 4         | Bangalore | Furniture   | 10000         |
| 5         | Mumbai    | Clothing    | 1200          |
| 6         | Mumbai    | Furniture   | 7000          |
| 7         | Delhi     | Electronics | 6200          |

**Example Output:**

| city   | category    | avg_price |
|--------|-------------|-----------|
| Mumbai | Electronics | 5000      |
| Delhi  | Electronics | 7100      |
| Mumbai | Clothing    | 1200      |
| Delhi  | Clothing    | 1500      |
| Mumbai | Furniture   | 7000      |

**Answer:**

```sql
SELECT   city, category, AVG(average_price) as avg_price
FROM     vendors
WHERE    city IN ('Mumbai', 'Delhi')
GROUP BY 1, 2
```




---

### 7. What's the purpose of a foreign key?

A foreign key is a field in a database table that links to the primary key of another table, establishing a connection between the two tables.

To demonstrate this concept, let's analyze IndiaMART's marketing analytics database which stores data from Google Ads campaigns:

`indiamart_ads_data`:

| ad_id | campaign_id| keyword | click_count| 
|-------|------------|-----------------|------------|
| 1 | 100 | IndiaMART pricing | 10 |
| 2 | 100 | IndiaMART reviews | 15 |
| 3 | 101 | IndiaMART alternatives | 7 |
| 4 | 101 | buy IndiaMART | 12 |

`campaign_id` is a foreign key. It references the `campaign_id` of the Google Ads campaign that each ad belongs to, establishing a relationship between the ads and their campaigns. This foreign key allows you to easily query the table to find out which ads belong to a specific campaign, or to find out which campaigns a specific ad belongs to.

It is also possible for a table to have multiple foreign keys that reference different primary keys in other tables. For example, the `indiamart_ads_data` table could have additional foreign keys for the `ad_group_id` of the ad group that each ad belongs to, and the `account_id` of the Google Ads account that the campaigns belong to.

---

### 8. Find the Average Quantity of Products per Order in IndiaMART

Given the "orders" and "order_details" tables on IndiaMART, **write a SQL query to find the average quantity of products per order.**

**Note:**

- Each row in the "orders" table represents an order with a unique order_id.

- Each row in the "order_details" table represents a product in an order, with quantity showing how many of that product are in the order.

`orders` **Example Input:**

| order_id | customer_id | order_date |
|----------|-------------|------------|
| 1001     | 57          | 2021-01-10 |
| 1002     | 108         | 2021-02-15 |
| 1003     | 25          | 2021-03-20 |
| 1004     | 76          | 2021-04-17 |
| 1005     | 109         | 2021-06-06 |

`order_details` **Example Input:**

| order_id | product_id | quantity |
|----------|------------|----------|
| 1001     | 4001       | 3        |
| 1001     | 5002       | 2        |
| 1002     | 3001       | 1        |
| 1002     | 4001       | 5        |
| 1003     | 2002       | 2        |
| 1004     | 3001       | 4        |
| 1004     | 5002       | 1        |
| 1005     | 2002       | 2        |
| 1005     | 3001       | 3        |

**Answer:**


```sql
SELECT   order_id, AVG(quantity) AS avg_quantity
FROM     orders o JOIN order_details od USING(order_id)
GROUP BY 1
ORDER BY 2 DESC;
```

---

### 9. Calculate Click-Through-Rates for IndiaMART's Digital Ads

IndiaMART has launched several digital ads that lead to various product pages on their website. Whenever a customer clicks on an ad, a log is inserted in the ad_clicks table. If the customer adds the product to their cart after viewing the product page, a log is added to the cart_adds table.

You are required to calculate the click-through rate from viewing a product toadding it to the cart for each product. The click-through rate is calculated as (number of cart adds / number of ad clicks) * 100.

**Write an SQL query that determines the click-through rate for each product.**

`ad_clicks` **Example Input:**

| click_id | user_id | click_time          | product_id |
|----------|---------|----------------------|------------|
| 1001     | 456     | 2022-07-05 11:00:00 | 60005      |
| 1002     | 789     | 2022-07-06 08:00:00 | 80909      |
| 1003     | 321     | 2022-07-06 09:00:00 | 60005      |
| 1004     | 654     | 2022-07-07 10:00:00 | 80909      |
| 1005     | 987     | 2022-07-07 11:00:00 | 60005      |

`cart_adds` **Example Input:**

| add_id | user_id | add_time            | product_id |
|--------|---------|----------------------|------------|
| 9001   | 456     | 2022-07-05 11:10:00 | 60005      |
| 9002   | 789     | 2022-07-06 08:10:00 | 80909      |
| 9003   | 654     | 2022-07-07 10:10:00 | 80909      |

**Answer:**

```sql
SELECT a.product_id, 
       (CAST(b.cart_adds AS FLOAT) / CAST(a.ad_clicks AS FLOAT)) * 100 AS clickthrough_rate
FROM   (
            SELECT   product_id, COUNT(*) AS ad_clicks 
            FROM     ad_clicks 
            GROUP BY 1
        ) a
LEFT JOIN 
        (
            SELECT   product_id, COUNT(*) AS cart_adds 
            FROM     cart_adds 
            GROUP BY 1
        ) b
ON a.product_id = b.product_id;
```


---

### 10. Can you describe the concept of a database index and the various types of indexes?


An index in a database is a data structure that helps to quickly find and access specific records in a table.

For example, if you had a database of IndiaMART customers, you could create a primary index on the customer_id column.

Having a primary index on the customer_id column can speed up performance in several ways. For example, if you want to retrieve a specific customer record based on their customer_id, the database can use the primary index to quickly locate and retrieve the desired record. The primary index acts like a map, allowing the database to quickly find the location of the desired record without having to search through the entire table.

Additionally, a primary index can also be used to enforce the uniqueness of the customer_id column, ensuring that no duplicate customer_id values are inserted into the table. This can help to prevent errors and maintain the integrity of the data in the table.

---

### 11.  Calculate Average Rating by Products, Rounded to Two Decimal Places

You are assisting IndiaMART with analyzing their product reviews data. They recently launched some new products and are mainly focused on understanding customer feedback for these items. Out of this, the company is particularly interested in the average rating for each product, with the results rounded to the nearest two decimal places.

They also want to calculate the absolute difference (using `ABS()` function) between the highest and lowest ratings of each product and the square root (using `SQRT()` function) of the total rating count of each product.

This data exercise is to help you use math functions and perform arithmetic operations in SQL.

Here is a sample data set consisting of 'reviews' table:

`reviews` **Example Input:**

| review_id | user_id | submit_date         | product_id | stars |
|-----------|---------|----------------------|------------|-------|
| 6171      | 123     | 06/08/2022 00:00:00 | 50001      | 4     |
| 7802      | 265     | 06/10/2022 00:00:00 | 69852      | 5     |
| 5293      | 362     | 06/18/2022 00:00:00 | 50001      | 3     |
| 6352      | 192     | 07/26/2022 00:00:00 | 69852      | 3     |
| 4517      | 981     | 07/05/2022 00:00:00 | 69852      | 2     |

**Expected Output:**

| product | avg_stars | abs_difference | sqrt_of_total_rating_count |
|---------|-----------|-----------------|----------------------------|
| 50001   | 3.50      | 1               | 1.41                       |
| 69852   | 3.33      | 3               | 1.73                       |

For this exercise, calculate:

- Average rating and round it to two decimal places 

- Absolute difference between the highest and lowest ratings

- Square root (rounded to two decimal places) of the total rating count for each product.

**Answer:**

```sql
SELECT   product_id,
         ROUND(AVG(stars), 2) as avg_stars, 
         ABS(MAX(stars) - MIN(stars)) as abs_difference,
         ROUND(SQRT(COUNT(review_id)), 2) as sqrt_of_total_rating_count
FROM     reviews
GROUP BY 1
```
---