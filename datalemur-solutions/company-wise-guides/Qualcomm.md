## 10 Qualcomm SQL Interview Questions

### 1. Identify Qualcomm's Top Spending Customers

Qualcomm is a company that sells a variety of tech-related products. They are interested in finding who their top spending (whale) customers are. 

Given the sales data, **write an SQL query that will identify the top 3 customers who have spent the most money on Qualcomm products in the last year.**

Assume a PostgreSQL database with the following tables:

`customers` **Example Input:**

| customer_id | name         | signup_date |
|-------------|--------------|-------------|
| 1001        | John Doe     | 01/01/2021  |
| 1002        | Jane Smith   | 03/03/2021  |
| 1003        | Mary Johnson | 04/04/2021  |

`sales` **Example Input:**

| sale_id | customer_id | product_id | sale_date  | price |
|---------|-------------|------------|------------|-------|
| 501     | 1001        | 2001       | 05/08/2021 | 100   |
| 502     | 1002        | 2002       | 06/10/2021 | 200   |
| 503     | 1003        | 2003       | 07/10/2021 | 150   |
| 504     | 1001        | 2004       | 08/20/2021 | 250   |
| 505     | 1001        | 2005       | 09/30/2021 | 200   |

**Answer:**

```sql
SELECT   name, SUM(price) as total_spent
FROM     customers c JOIN sales s USING(customer_id)
WHERE    sale_date BETWEEN '01/01/2021' and '12/31/2021'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    3;
```

---

### 2. Calculate Rolling Monthly Average Ratings for Each Product

Imagine you are a data analyst at Qualcomm. The company wants to understand how each of their Qualcomm chipsets is rated on average every month, to assess and improve their product quality over time.

**Write a SQL query to calculate a rolling average rating for each `product_id` for every month.** 

The rolling average should be calculated from the start of the dataset up to the current month.

`reviews` **Example Input:**

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|-------------|------------|-------|
| 1         | 123     | 02/01/2022  | 101        | 4     |
| 2         | 456     | 02/15/2022  | 102        | 5     |
| 3         | 789     | 02/21/2022  | 103        | 3     |
| 4         | 123     | 03/05/2022  | 101        | 5     |
| 5         | 456     | 03/10/2022  | 102        | 4     |
| 6         | 789     | 03/25/2022  | 103        | 2     |
| 7         | 123     | 04/01/2022  | 101        | 3     |
| 8         | 456     | 04/15/2022  | 102        | 4     |
| 9         | 789     | 04/20/2022  | 103        | 5     |

**Example Output:**

| month_year | product_id | avg_stars |
|------------|------------|-----------|
| 2022-02    | 101        | 4.00      |
| 2022-02    | 102        | 5.00      |
| 2022-02    | 103        | 3.00      |
| 2022-03    | 101        | 4.50      |
| 2022-03    | 102        | 4.50      |
| 2022-03    | 103        | 2.50      |
| 2022-04    | 101        | 4.00      |
| 2022-04    | 102        | 4.33      |
| 2022-04    | 103        | 3.33      |

**Answer:**

```sql
SELECT   TO_CHAR(submit_date, 'YYYY-MM') AS year_month, 
         product_id,
         ROUND(AVG(stars) OVER(PARTITION BY product_id
                               ORDER BY TO_CHAR(submit_date, 'YYYY-MM') 
                               RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
               , 2)AS avg_stars
FROM     reviews
ORDER BY 1, 2
```
---

### 3. What is database normalization?

Database normalization is the process of breaking down a table into smaller and more specific tables and defining relationships between them via foreign keys. 

This minimizes redundancy, and creates a database that's more flexible, scalable, and easier to maintain. It also helps to ensure the integrity of the data by minimizing the risk of data inconsistencies and anomalies.

---

### 4. Filter Customer Records

Qualcomm is conducting an internal review to study the data usage patterns of its customers. They would like to filter their customer database based on the customers who are on a "Premium" plan and have their data usage level above 50 GB for the month of July 2022.

Assume we have the following available tables:

`customer` **Example Input:**

| customer_id | name             | plan_type |
|-------------|-------------------|-----------|
| 1001        | John Doe          | Basic     |
| 1002        | Jane Smith        | Premium   |
| 1003        | Harry Potter      | Premium   |
| 1004        | Hermione Granger  | Basic     |

`data_usage` **Example Input:**

| usage_id | customer_id | usage_date | data_used_gb |
|----------|-------------|------------|--------------|
| 1        | 1001        | 07/01/2022 | 40           |
| 2        | 1002        | 07/15/2022 | 60           |
| 3        | 1003        | 07/20/2022 | 55           |
| 4        | 1004        | 07/05/2022 | 30           |
| 5        | 1002        | 07/25/2022 | 20           |

**Example Output:**

| customer_id | name        |
|-------------|-------------|
| 1002        | Jane Smith  |
| 1003        | Harry Potter|

**Answer:**

```sql
SELECT   customer_id, name
FROM     customer c JOIN data_usage du USING(customer_id)
WHERE    plan_type = 'Premium' AND 
         data_used_gb > 50 AND
         DATE_TRUNC('month', usage_date) = '2022-07-01'
GROUP BY 1, 2
```

---

### 5. Difference Between Cross Join and Natural Join

Imagine you are organizing a party and have two database tables: one table of people you want to invite and another list of food items you want to serve.

A **cross join** would be like inviting every person on your list to the party and serving them every food item on the menu, regardless of whether they like the food or not. So, if you had 10 people on your invite list and 5 food items on the menu, you would generate all 50 different combinations of people and food (10 x 5 = 50).

On the other hand, a **natural join** would be like inviting only the people who like the food items on the menu (based on doing an inner/left/right/outer JOIN on a common key like food_id).


---


### 6. Calculate the Average Power Consumption of Qualcomm Chipsets

As an Electrical Design Engineer at Qualcomm, understanding how much power chipsets consume on average is crucial. 

**Write a SQL query to find the average power consumption (mW) by chipset category for all Qualcomm chipsets recorded in our database.**

`chipsets` **Example Input:**

| chipset_id | category   | model         | power_consumption_mW |
|------------|------------|----------------|--------------------|
| 1          | "5G"       | "Snapdragon X55"| 650                |
| 2          | "5G"       | "Snapdragon X60"| 700                |
| 3          | "Bluetooth"| "QCC5100"      | 150                |
| 4          | "Bluetooth"| "QCC3040"      | 120                |
| 5          | "4G"       | "MDM9x07"      | 500                |
| 6          | "4G"       | "Snapdragon 210"| 540                |
| 7          | "Wifi"     | "QCA6390"      | 280                |

**Example Output:**

| category   | average_power_consumption_mW |
|------------|------------------------------|
| 5G         | 675                          |
| Bluetooth  | 135                          |
| 4G         | 520                          |
| Wifi       | 280                          |

**Answer:**

```sql
SELECT   category, AVG(power_consumption_mW) as average_power_consumption_mW
FROM     chipsets
GROUP BY 1
```

---

### 7. Difference Between UNION and UNION ALL

The `UNION` operator combines two or more results from multiple `SELECT` queries into a single result. If it encounters duplicate rows, the multiple copies are removed (so there's only one instance of each would-be duplicate in the result set). Here's an example of a `UNION` operator which combines all rows from `table1` and `table2` (making sure each row is unique):

```sql
SELECT columns FROM table1    
UNION    
SELECT columns FROM table2;    
```

The `UNION ALL` operator is similar to the `UNION` operator but it does **NOT** remove duplicate rows!

---

### 8. Analyzing Click-through Conversion Rate

As part of the marketing analytics team at Qualcomm, one main metric of interest is the click-through conversion rate. This rate refers to the proportion of customers who not only clicked on a digital advertisement, but also proceeded to purchase the advertised product. 

Assume you have two tables:

- `ad_clicks`, which records whenever a customer clicks on an ad.

- `purchases`, which records whenever a customer purchases a product that was advertised.

Given the data in these tables, write a SQL query that provides the click-through conversion rate, defined as the total number of ad clicks that resulted in a purchase divided by the total number of ad clicks, for each unique advertisement.

`ad_clicks` **Example Input:**

| click_id | user_id | click_date | ad_id |
|----------|---------|------------|-------|
| 101      | 1       | 2022-06-20 | 202   |
| 102      | 2       | 2022-06-21 | 203   |
| 103      | 3       | 2022-06-22 | 202   |
| 104      | 4       | 2022-06-23 | 204   |
| 105      | 5       | 2022-06-24 | 203   |

`purchases` **Example Input:**

| purchase_id | user_id | purchase_date | ad_id |
|-------------|---------|---------------|-------|
| 501         | 1       | 2022-06-21    | 202   |
| 502         | 2       | 2022-06-22    | 203   |
| 503         | 6       | 2022-06-23    | 204   |
| 504         | 7       | 2022-06-24    | 205   |
| 505         | 8       | 2022-06-25    | 206   |

**Answer:**

```sql
SELECT A.ad_id, 
       CASE WHEN P.total_purchases IS NULL THEN 0 ELSE P.total_purchases END total_purchases, 
       A.total_clicks, 
       (CASE WHEN P.total_purchases IS NULL THEN 0 ELSE P.total_purchases END * 1.0 / A.total_clicks) as conversion_rate
FROM (
        SELECT   ad_id, COUNT(*) as total_clicks 
        FROM     ad_clicks 
        GROUP BY 1) A 
   LEFT JOIN (
        SELECT   ad_id, COUNT(*) as total_purchases 
        FROM     purchases 
        GROUP BY 1 ) P 
ON A.ad_id = P.ad_id ;
```


---

### 9. Calculating the Average Sales Per Region of Qualcomm Products

As the data analyst for Qualcomm, your task is to calculate the average sales per region for each product every month. Each row in the `sales` table represents a sale of a certain product in a specific region. The `region_id` columns identify the region where the sale was made.

`sales` **Example Input:**

| sale_id | product_id | date_sold  | price | region_id    |
|---------|------------|------------|-------|--------------|
| 2567    | SQN6720    | 2021-06-08 | 500   | North America|
| 1984    | SQN6731    | 2021-06-10 | 600   | Asia Pacific |
| 5249    | SQN6720    | 2021-07-18 | 500   | Europe       |
| 3675    | SQN6731    | 2021-07-26 | 600   | North America|
| 4421    | SQN6712    | 2021-08-05 | 700   | Europe       |

**Answer:**

```sql
SELECT   TO_CHAR(date_sold, 'YYYY-MM') AS month,
         region_id,
         product_id,
         AVG(price) AS avg_sales
FROM     sales
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
```

--- 

### 10. How can you select records without duplicates from a table?

**Answer**: 

The DISTINCT clause is used to remove all duplicate records from a SELECT query.

For example, if you had a table of open jobs Qualcomm was hiring for, and wanted to see what are all the unique job titles that were currently available at the company, you could write the following query:

```sql
SELECT DISTINCT job_title 
FROM   qualcomm_open_jobs;
```

---