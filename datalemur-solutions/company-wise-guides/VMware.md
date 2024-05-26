## 8 VMWare SQL Interview Questions


### 1. Analyzing VMware Product Version Usage

As a VMware system administrator, you want to understand the usage of different product versions in your company. You have the following two tables:

**Example Input:**

`vm_products`:

product_id | product_name | version
-----|-----|-----
101 | VMware vSphere | 6.7
102 | VMware vSphere | 7.0
103 | VMware NSX-T | 2.4
104 | VMware NSX-T | 2.5

`vm_usage`:  

device_id | product_id | usage_date
-----|-----|-----
d001 | 101 | 2022-10-04
d002 | 102 | 2022-10-05
d003 | 102 | 2022-10-06
d004 | 103 | 2022-10-07
d005 | 104 | 2022-10-08

**Write a SQL query to list the product name, version and the number of unique devices that used each product version in each month** (for all the records in vm_usage).

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM usage_date) AS month,
         product_name, 
         version,  
         COUNT(DISTINCT device_id) AS device_count
FROM     vm_products vp JOIN vm_usage vu USING(product_id)
GROUP BY 1, 2, 3
```

---

### 2. VMWare Product User Analysis

As a data analyst at VMWare, you are presented with two data tables. One table, users, contains information about the users of VMware products, including columns for user_id, user_name, and registration_date. The other table, product_usage, contains information about each instance of product use, including columns for usage_id, user_id, product_name, product_version, and usage_date.

You are asked to help understand the company's user base and their product usage. Specifically, you are tasked to identify users who have used the product 'vSphere' version '7.0' more than 10 times since '2021-01-01'.

**Provide a list of user_names who meet these criteria and sort the output based on user_name in ascending alphanumeric order.**

**Example Input:**

`users`:

user_id | user_name | registration_date
-----|-----|-----
1001 | user1 | 05/10/2020
1002 | user2 | 06/12/2020
1003 | user3 | 08/24/2020 
1004 | user4 | 11/10/2020
1005 | user5 | 01/01/2021

`product_usage`:

usage_id | user_id | product_name | product_version | usage_date
-----|-----|-----|-----|-----
1 | 1001 | vSphere | 7.0 | 01/10/2021
2 | 1001 | vSphere | 7.0 | 05/10/2021
3 | 1001 | vSphere | 7.0 | 06/20/2021
4 | 1002 | vSphere | 6.7 | 07/24/2021
5 | 1001 | vSphere | 7.0 | 08/30/2021
6 | 1003 | vSphere | 7.0 | 09/28/2021
7 | 1003 | vSphere | 7.0 | 10/04/2021
8 | 1001 | vSphere | 7.0 | 01/20/2022
9 | 1003 | vSphere | 7.0 | 05/01/2022
10 | 1001 | vSphere | 7.0 | 06/01/2022

**Answer:**

```sql
WITH CTE as (
	SELECT   DISTINCT user_id
	FROM     product_usage
	WHERE    product_name='vSphere' and 
		     product_version='7.0' and 
             usage_date > '2021-01-01'
	GROUP BY 1
	HAVING   COUNT(*) > 10
)
SELECT user_id, user_name
FROM   CTE JOIN users USING(user_id)
```

---

### 3. What does adding 'DISTINCT' to a SQL query do?

**Answer:**

The DISTINCT keyword added to a SELECT statement can be used to get records without duplicates.

For example, say you had a table of VMware customers:

name | city
-----|-----
Akash | SF
Brittany | NYC
Carlos | NYC
Diego | Seattle
Eva | SF
Faye | Seattle

Suppose you wanted to figure out which cities the customers lived in, but didn't want duplicate results, you could write a query like this:

```sql
SELECT DISTINCT city 
FROM   vmware_customers;
```

Your result would be:

city |
-----|
SF |
NYC  |
Seattle |

---

### 4. Filter Customers by Subscription and Usage

Given a database with two tables 'customers' and 'usage', filter out the customers who have an 'Enterprise' level subscription and have used more than 1000 resources.

The 'customers' table has the fields 'customer_id', 'subscription_level' and 'country', and the 'usage' table has the fields 'customer_id', 'resources_used' and 'usage_date'. Each row in the usage table represents the usage for a particular day.

**Example Input:**

`customers`:

customer_id | subscription_level | country 
-----|-----|-----
101 | Enterprise | USA
102 | Basic | Canada
103 | Enterprise | Germany
104 | Free | USA
105 | Enterprise | USA

`usage`:

customer_id | resources_used | usage_date
-----|-----|-----
101 | 1023 | 06/08/2022
103 | 832 | 06/10/2022
101 | 765 | 06/11/2022
105 | 1204 | 06/14/2022
104 | 1095 | 06/15/2022

**Return a list of customer_ids and countries of customers who meet these conditions.**

**Answer:**

```sql
SELECT c.customer_id, c.country
FROM   customers c JOIN usage u USING(customer_id)
WHERE  c.subscription_level = 'Enterprise' AND u.resources_used > 1000;
```

---

### 5. Can you provide a comparison of cross join and natural join?

**Answer:**

A cross join is a JOIN operation in SQL that creates a new table by pairing each row from the first table with every row from the second table. It is also referred to as a cartesian join. 

In contrast, a natural join combines rows from two or more tables based on their common columns, forming a new table. 

Natural joins are called "natural" because they rely on the natural relationship between the common columns in the joined tables.

Here's an example of a cross join:

```sql
SELECT products.name AS product, colors.name AS color
FROM products
CROSS JOIN colors;
```

Here's a natural join example using two tables, VMware employees and VMware managers:

```sql
SELECT *
FROM vmware_employees
LEFT JOIN vmware_managers
ON vmware_employees.id = vmware_managers.id
WHERE vmware_managers.id IS NULL;
```

This natural join returns all rows from VMware employees where there is no matching row in managers based on the id column.

One significant difference between cross joins and natural joins is that the former do not require common columns between the tables being joined, while the latter do. 

Another distinction is that cross joins can generate very large tables if the input tables have a large number of rows, while natural joins only produce a table with the number of rows equal to the number of matching rows in the input tables.

--- 



### 6. Average Purchase Amount per Month for Each Product

As a data analyst at VMware, your task is to **calculate the average purchase amount per month for each product** we sell. This will help the product management team to understand how the sales of each product are distributed over time.

The `purchases` table records every purchase made by a user. Assume that each row represents a separate purchase of a VMware product, the `purchase_amount` is in US dollars, and the purchase_date is of the format `MM/DD/YYYY HH24:MI:SS`

**Example Input:**

`purchases`:

purchase_id | user_id | purchase_date | product_id | purchase_amount
-----|-----|-----|-----|-----
105 | 123 | 03/15/2022 16:30:00 | 10001 | 95.50
210 | 265 | 03/28/2022 10:45:00 | 10552 | 120.00
345 | 362 | 04/05/2022 18:00:00 | 10001 | 105.00
124 | 192 | 05/17/2022 14:00:00 | 10552 | 115.00
675 | 981 | 06/30/2022 09:00:00 | 10552 | 125.00

**Expected Output:**

mth | product | avg_purchase_amount
-----|-----|-----
3 | 10001 | 95.50
3 | 10552 | 120.00
4 | 10001 | 105.00
5 | 10552 | 115.00
6 | 10552 | 125.00

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM purchase_date) AS mth, 
         product_id AS product,
         AVG(purchase_amount) AS avg_purchase_amount
FROM     purchases
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 7. Do NULLs in SQL mean the same thing as a zero?

**Answer:**

In SQL, zero's are numerical values which can be used in calculations and comparisons just like any other number. A blank space, also known as an empty string, is a character value and can be used in character manipulation functions and comparisons.

NULLs aren't the same as zero's or blank spaces. NULLs represent unknown, missing, or not applicable values. They are not included in calculations and comparisons involving NULL values always result in NULL.

---

### 8. Analyze Product Usage Based on Customer Subscriptions

Given two tables, customers and subscriptions, write a SQL query to analyze the product usage of VMware's customers. The customers table includes information about the customer with their respective customer_id, customer_name, contact_no, and email. The subscriptions table contains columns subscription_id, customer_id, product_id, start_date and end_date.

The goal is to find how many customers are using each product right now, i.e., their subscription end date is later than today's date. 

Output should show the product_id and the count of customer_id using that product.

**Example Input:**

`customers`:

customer_id | customer_name | contact_no | email
-----|-----|-----|-----
123 | Jane Smith | 9876543210 | j.smith@example.com
456 | John Doe | 9876543211 | j.doe@example.com
789 | Emily Walker | 9876543212 | e.walker@example.com
321 | Ravi Kumar | 9876543213 | r.kumar@example.com
654 | Lee Wong | 9876543214 | l.wong@example.com

`subscriptions`: 

subscription_id | customer_id | product_id | start_date | end_date
-----|-----|-----|-----|-----
1 | 123 | 1 | 2022-01-07 | 2023-01-07
2 | 456 | 2 | 2022-06-09 | 2023-06-09
3 | 123 | 2 | 2022-07-10 | 2023-07-10
4 | 789 | 1 | 2021-12-17 | 2022-12-17
5 | 321 | 3 | 2022-08-16 | 2023-08-16
6 | 654 | 1 | 2022-07-01 | 2023-07-01
7 | 789 | 3 | 2022-04-22 | 2023-04-22

**Answer:**

```sql
SELECT   product_id, COUNT(customer_id) as customer_count
FROM     subscriptions
WHERE    end_date > CURRENT_DATE
GROUP BY 1
ORDER BY 2 DESC;
```

---