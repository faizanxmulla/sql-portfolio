## 10 IBM SQL Interview Questions

### 1. Identify IBM's High Capacity Users

In IBM, a crucial part of user base are high-volume purchasers, who buy IBM products or services frequently and in large quantities. They are identified as 'whale users'. Assuming we have a database table tracking all purchases, your task is to write a SQL query to identify users who've purchased more than $10,000 worth of goods in the past month.

The purchases table is structured as follows:

`purchases` Example Input:
purchase_id |	user_id |	date_of_purchase |	product_id |	amount_spent |
--|--|--|--|--|
2171 |	145 |	08/22/2022 00:00:00 |	43001 |	1000 |
3022 |	578 |	08/24/2022 00:00:00 |	25852 |	4000 |
4933 |	145 |	08/31/2022 00:00:00 |	43001 |	7000 |
6322 |	248 |	08/19/2022 00:00:00 |	25852 |	2000 |
4717 |	578 |	08/12/2022 00:00:00 |	25852 |	7000 |

Answer:

```sql
SELECT   user_id, SUM(amount_spent) as total_spent
FROM     purchases
WHERE    date_of_purchase BETWEEN date '2022-08-01' AND '2022-08-31'
GROUP BY 1
HAVING   SUM(amount_spent) > 10000;
```

---

### 2. Calculate the Monthly Average Ratings for Each Product

IBM sells a variety of technological products, which are regularly reviewed by users on its platform. Determine the average monthly rating for each product, rounded to 2 decimal places.

For this task, consider the following two tables:

`products` Example Input:

product_id |	product_name |
--|--|
50001 |	"IBM Quantum Computer" |
69852 |	"IBM Thinkpad X1" |


`reviews` Example Input:

review_id |	user_id |	submit_date |	product_id |	stars |
--|--|--|--|--|
6171 |	123 |	2022-06-08 |	50001 |	4 |
7802 |	265 |	2022-06-10 |	69852 |	4 |
5293 |	362 |	2022-06-18 |	50001 |	3 |
6352 |	192 |	2022-07-26 |	69852 |	3 |
4517 |	981 |	2022-07-05 |	69852 |	2 |

Write a SQL query to determine the average monthly rating for each product.

Answer:
```sql
SELECT   DATE_TRUNC('month', submit_date) AS mth, 
         p.product_name AS product, 
         ROUND(AVG(stars), 2) AS avg_stars
FROM     reviews r JOIN products p USING(product_id)
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 3. Can you explain the distinction between cross join and natural join?

Cross joins and natural joins are two types of JOIN operations in SQL that are used to combine data from multiple tables. 

A **cross join** creates a new table by combining each row from the first table with every row from the second table, and is also known as a cartesian join. 

On the other hand, a **natural join** combines rows from two or more tables based on their common columns, forming a new table. One key difference between these types of JOINs is that cross joins do not require common columns between the tables being joined, while natural joins do.

Here's an example of a cross join:
```sql
SELECT     p.name AS product, c.name AS color
FROM       products p CROSS JOIN colors c;
```
If you have 20 products and 10 colors, that's 200 rows right there!

Here's a natural join example using two tables, IBM employees and IBM managers:

```sql
SELECT *
FROM   ibm_employees e LEFT JOIN ibm_managers m USING(id)
WHERE  m.id IS NULL;
```
This natural join returns all rows from IBM employees where there is no matching row in managers based on the id column.

---

### 4. Average Duration of Employee's Service

Given the data on IBM employees, can you find the average duration of service for employees across different departments? The Duration of service is represented as end_date - start_date. If end_date is NULL, consider it as the current date.

`employee_service` Example Input:

employee_id |	name |	start_date |	end_date |	department |
--|--|--|--|--|
101 |	John |	2015-01-15 |	2020-06-30 |	Technology |
102 |	Emma |	2016-08-01 |	NULL |	Management |
103 |	Ava |	2017-05-30 |	2019-08-01 |	Strategy |
104 |	Oliver |	2018-11-11 |	NULL |	Technology |
105 |	Sophia |	2020-01-17 |	NULL |	Management |

Answer:

```sql
SELECT   department,
         AVG(
            CASE 
                WHEN end_date IS NULL THEN (CURRENT_DATE - start_date)
                ELSE (end_date - start_date)
            END
         ) AS avg_service_duration
FROM     employee_service
GROUP BY 1
```

---

### 5. What's the difference between UNION and UNION ALL?

Both UNION and UNION ALL are used to combine the results of two or more SELECT statements into a single result set.

However, UNION only includes one instance of a duplicate, whereas UNION ALL includes duplicates.

---

### 6. Analyze Click-Through Conversions Rates for IBM's Digital Products

Imagine that you are working for IBM and the marketing team wants to analyze the click-through conversion rates for their digital products. This involves the number of times a product is viewed, added to the cart and finally purchased.

For this scenario, let's assume that you have access to three tables.

`product_views` Example Input:

view_id |	user_id |	view_date |	product_id |
--|--|--|--|
211 |	4895 |	06/10/2022 00:00:00 |	1325 |
364 |	2375 |	06/08/2022 00:00:00 |	3452 |
897 |	4403 |	06/14/2022 00:00:00 |	1325 |
999 |	3318 |	07/04/2022 00:00:00 |	9648 |

`product_cart` Example Input:

cart_id |	user_id |	add_to_cart_date |	product_id |
--|--|--|--|
113 |	4895 |	06/11/2022 00:00:00 |	1325 |
570 |	2375 |	06/09/2022 00:00:00 |	3452 |
953 |	4403 |	06/15/2022 00:00:00 |	1325 |

`product_purchases` Example Input:

purchase_id |	user_id |	purchase_date |	product_id |
--|--|--|--|
118 |	4895 |	06/12/2022 00:00:00 |	1325 |
596 |	2375 |	06/10/2022 00:00:00 |	3452 |

**The question is:** What is the click-through conversion rate, defined as the number of purchases per view, for each product?

Answer:

```sql
WITH view_to_cart AS (
    SELECT   v.product_id, COUNT(DISTINCT v.user_id) as views, COUNT(DISTINCT c.user_id) as cart_adds
    FROM     product_views v LEFT JOIN product_cart c ON v.user_id = c.user_id AND v.product_id = c.product_id
    GROUP BY 1
),
cart_to_purchase AS (
    SELECT c.product_id, COUNT(DISTINCT c.user_id) as cart_adds, COUNT(DISTINCT p.user_id) as purchases
    FROM product_cart c LEFT JOIN product_purchases p ON c.user_id = p.user_id AND c.product_id = p.product_id
    GROUP BY 1
)
SELECT   v.product_id, v.views, v.cart_adds, IFNULL(p.purchases, 0) as purchases, (IFNULL(p.purchases,0)::float / v.views::float) as conversion_rate
FROM     view_to_cart v LEFT JOIN cart_to_purchase p USING(product_id)
ORDER BY 5 DESC;
```

---

### 7. What is the process for finding records in one table that do not exist in another?

To find records in one table that aren't in another, you can use a LEFT JOIN and check for NULL values in the right-side table.

Here's an example using two tables, IBM employees and IBM managers:

```sql
SELECT *
FROM   ibm_employees e LEFT JOIN ibm_managers m USING(id)
WHERE  m.id IS NULL;
```
This query returns all rows from IBM employees where there is no matching row in managers based on the id column.

You can also use the EXCEPT operator in PostgreSQL and Microsoft SQL Server to return the records that are in the first table but not in the second. Here is an example:

```sql
SELECT * 
FROM   ibm_employees
EXCEPT
SELECT * 
FROM   ibm_managers
```
This will return all rows from employees that are not in managers. The EXCEPT operator works by returning the rows that are returned by the first query, but not by the second.

Note that EXCEPT isn't supported by all DBMS systems, like in MySQL and Oracle (but have no fear, since you can use the MINUS operator to achieve a similar result).

---

### 8. Average Sales of IBM Products

As a data analyst at IBM, you have been asked to analyze sales data from the IBM e-commerce platform. 

Given a table named sales with columns sale_id, product_id, customer_id, sale_date and quantity, write a SQL query to find out the average sales quantity for each product on a monthly basis.

`sales` Example Input:

sale_id |	product_id |	customer_id |	sale_date |	quantity |
--|--|--|--|--|
1 |	1001 |	123 |	03/01/2022 |	10 |
2 |	1002 |	265 |	03/04/2022 |	5 |
3 |	1001 |	478 |	03/15/2022 |	7 |
4 |	1003 |	192 |	04/01/2022 |	3 |
5 |	1002 |	123 |	04/05/2022 |	8 |

Example Output:

month |	product |	avg_quantity |
--|--|--|
3 |	1001 |	8.50 |
3 |	1002 |	5.00 |
4 |	1002 |	8.00 |
4 |	1003 |	3.00 |

Answer:

```sql
SELECT   EXTRACT(MONTH FROM sale_date) AS month, 
         product_id AS product, 
         AVG(quantity) AS avg_quantity
FROM     sales
GROUP BY 1, 2
ORDER BY 1, 2;
```

---

### 9. Analyzing Customers and Orders Data

As a data analyst at IBM, you are required to analyze data from two given tables; customers and orders. Write a SQL query in PostgreSQL to find out the total amount spent by each customer and the total number of orders placed by each customer. Join customers and orders tables using appropriate keys.

Sample data from the customers table is as follows:

`customers` Example Input:

|**customer_id**|**first_name**|**last_name**|
|:----|:----|:----|
|101|John|Doe|
|102|Jane|Smith| 
|103|Michael|Johnson|
|104|Emma|Wilson|
|105|Oliver|Taylor|

Sample data from the orders table is as follows:

`orders` Example Input:

|**order_id**|**customer_id**|**order_total**|**order_date**|
|:----|:----|:----|:----|
|1001|101|200.00|2022-06-25|
|1002|101|300.00|2022-07-10|
|1003|102|150.00|2022-06-14|
|1004|103|250.00|2022-07-05|
|1005|104|350.00|2022-06-30|
|1006|105|300.00|2022-07-20|
|1007|101|100.00|2022-08-01|

Answer:
```sql
SELECT   c.first_name, c.last_name, COUNT(o.order_id) as total_orders, SUM(o.order_total) as total_amount_spent
FROM     customers c JOIN orders o USING(customer_id)
GROUP BY 1, 2
```

---

### 10. What do the EXCEPT / MINUS operators do, and can you give an example?

The MINUS/EXCEPT operator is used to remove to return all rows from the first SELECT statement that are not returned by the second SELECT statement.

Note that EXCEPT is available in PostgreSQL and SQL Server, while MINUS is available in MySQL and Oracle (but don't worry about knowing which DBMS supports which exact commands since IBM interviewers aren't trying to trip you up on memorizing SQL syntax).

For a tangible example of EXCEPT in PostgreSQL, suppose you were doing an HR Analytics project for IBM, and had access to IBM's contractors and employees data. Assume that some employees were previously contractors, and vice versa, and thus would show up in both tables.

You could use EXCEPT operator to find all contractors who never were a employee using this query:

```sql
SELECT first_name, last_name
FROM   ibm_contractors

EXCEPT

SELECT first_name, last_name
FROM   ibm_employees
```