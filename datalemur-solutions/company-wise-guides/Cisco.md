## 8 Cisco Systems SQL Interview Questions

### 1. Calculate customer product scores over time

Cisco Systems is interested in how their different network components' quality ratings vary over time by clients. Their products' feedback is collected and stored. 

As a Data Analyst for Cisco, write a SQL query to calculate the average star ratings for each product per month.

Given the `product_reviews` table that tracks each product review submitted by the customers:

`product_reviews` Example Input:

| review_id | client_id | submit_date | product_id | stars |
| --------- | --------- | ----------- | ---------- | ----- |
| 617       | 11230     | 2022-06-08  | RTR-90     | 1     |
| 6780      | 22650     | 2022-06-10  | SWT-1050   | 4     |
| 24529     | 33620     | 2022-06-18  | RTR-90     | 3     |
| 3635      | 21920     | 2022-07-26  | SWT-1050   | 2     |
| 3451      | 79810     | 2022-07-05  | SWT-1050   | 2     |

We would like to produce the following output:

Example Output:

| month | product  | avg_stars |
| ----- | -------- | --------- |
| 6     | RTR-90   | 3.5       |
| 6     | SWT-1050 | 4.0       |
| 7     | SWT-1050 | 2.5       |

#### `Solution`:

```sql
SELECT   EXTRACT(MONTH FROM submit_date) as month, product_id as product, AVG(stars) as avg_stars
FROM     product_reviews
GROUP BY 1, 2
ORDER BY 1, 2


-- alternative for handling date: DATE_TRUNC('month', submit_date) AS month
```

---

### 2. Calculate the average bandwidth usage per Cisco router

Assume that Cisco wants to keep track of the average bandwidth usage of their routers for managing their network infrastructure effectively. Data is logged in a table for each time a router makes a connection.

Given a table `connections` with the fields `router_id`, `connect_time`, and `bandwidth_used`, can you write a SQL query to calculate the average bandwidth usage per router?

`connections` Example Input:

| connection_id | router_id | connect_time        | bandwidth_used |
| ------------- | --------- | ------------------- | -------------- |
| 1             | 1001      | 01/01/2022 00:00:00 | 5000           |
| 2             | 1001      | 01/01/2022 01:00:00 | 7000           |
| 3             | 1002      | 01/01/2022 00:30:00 | 9000           |
| 4             | 1002      | 01/01/2022 02:30:00 | 3000           |
| 5             | 1003      | 01/01/2022 01:45:00 | 6000           |

Example Output:

| router_id | avg_bandwidth_used |
| --------- | ------------------ |
| 1001      | 6000.0             |
| 1002      | 6000.0             |
| 1003      | 6000.0             |

#### `Solution`:

```sql
SELECT   router_id, AVG(bandwidth_used) as avg_bandwidth
FROM     connections
GROUP BY 1
```

---

### 3. What distinguishes a left join from a right join?

#### `Answer`:

In SQL, a join generally retrieves rows from multiple tables and combines them into a single result set. For an example of the difference between a left vs. right join, suppose you had a table of Cisco orders and Cisco customers.

A `LEFT JOIN` retrieves all rows from the left table (in this case, the Orders table) and any matching rows from the right table (the Customers table). If there is no match in the right table, NULL values will be returned for the right table's columns.

A `RIGHT JOIN` combines all rows from the right table (in this case, the Customers table) and any matching rows from the left table (the Orders table). If there is no match in the left table, NULL values will be displayed for the left table's columns.

---

### 4. Analyzing Click-Through-Rates for Cisco's Digital Ads

Cisco has been running various digital ad campaigns. They are particularly interested in understanding how effective these campaigns are in driving users to click and navigate to their product pages. For this, they monitor the click-through rates (CTR) of these campaigns. 

The CTR is calculated as the total number of clicks that an ad receives divided by the total number of impressions (times the ad was served).

Sample Input Data:

`ad_impressions` Table:

| impression_id | ad_id | impression_date |
| ------------- | ----- | --------------- |
| 2541          | 10101 | 07/20/2021      |
| 12485         | 10201 | 07/21/2021      |
| 9847          | 10101 | 07/22/2021      |
| 7462          | 10301 | 07/23/2021      |
| 6259          | 10401 | 07/24/2021      |

`ad_clicks` Table:

| click_id | ad_id | click_date |
| -------- | ----- | ---------- |
| 3257     | 10101 | 07/20/2021 |
| 2758     | 10101 | 07/21/2021 |
| 9846     | 10301 | 07/24/2021 |
| 6259     | 10401 | 07/24/2021 |
| 1996     | 10201 | 07/26/2021 |

**Write a query to calculate the daily click-through rates (CTR) for each ad in the month of July 2021.**

#### `Solution`:

```sql
WITH ad_impressions AS (
    SELECT   ad_id,
             impression_date,
             COUNT(*) AS total_impressions
    FROM     ad_impressions
    WHERE    TO_CHAR(impression_date, 'YYYYMM') = '202107'
    GROUP BY 1, 2
),
ad_clicks AS (
    SELECT   ad_id,
             click_date,
             COUNT(*) AS total_clicks
    FROM     ad_clicks
    WHERE    TO_CHAR(click_date, 'YYYYMM') = '202107'
    GROUP BY 1, 2
),
CTR AS (
    SELECT ai.ad_id,
           ai.impression_date AS date,
           COALESCE(ac.total_clicks, 0) AS total_clicks,
           ai.total_impressions,
           CASE 
                WHEN ai.total_impressions > 0 THEN ac.total_clicks / ai.total_impressions
                ELSE 0
            END AS click_rate
    FROM   ad_impressions ai LEFT JOIN ad_clicks ac ON ai.ad_id = ac.ad_id AND ai.impression_date = ac.click_date
)
SELECT ad_id, date, total_clicks, total_impressions, click_rate
FROM   CTR;
```

---

### 5. What's the difference between a unique and non-unique index?

#### `Answer`:

Some `similarities` between unique and non-unique indexes include :


1. Both types improve the performance of SQL queries by providing a faster way to lookup the desired data.

2. Both types use an additional data structure to store the indexed data, which requires additional storage space which impacts write performance.

3. Both types of indexes can be created on one or more columns of a table.


Some `differences` between unique and non-unique indexes include:

1. A unique index enforces the uniqueness of the indexed columns, meaning that no duplicate values are allowed in the indexed columns. A non-unique index allows duplicate values in the indexed columns.

2. A unique index can be used to enforce the primary key of a table, but a non-unique index cannot.

3. A unique index can have a maximum of one NULL value in the indexed columns, but a non-unique index can have multiple NULLs



---

### 6. Calculate the average revenue per quarter for each product

Cisco being a multinational technology conglomerate, sells various products. The financial team needs to analyze their product performance from the revenue perspective on a quarterly basis. Using the data provided, write an SQL query to calculate the average revenue per quarter for each product over the year.

`sales` Example Input:

| sale_id | product_id | sale_date  | quantity_sold | sales_price |
| ------- | ---------- | ---------- | ------------- | ----------- |
| 12563   | 3890       | 01/13/2021 | 4             | 7000        |
| 78541   | 10501      | 04/02/2021 | 21            | 5000        |
| 23563   | 3890       | 02/21/2021 | 3             | 7000        |
| 56841   | 10501      | 06/23/2021 | 11            | 5000        |
| 96978   | 79503      | 03/18/2021 | 5             | 5500        |
| 98523   | 3890       | 08/27/2021 | 3             | 7000        |

Example Output:

| quarter | product_id | avg_revenue |
| ------- | ---------- | ----------- |
| 1       | 3890       | 28000       |
| 1       | 10501      | 15000       |
| 1       | 87952      | 7500        |
| 2       | 11051      | 15000       |
| 3       | 3890       | 21000       |

#### `Solution`:

```sql
SELECT   EXTRACT(QUARTER FROM submit_date) as quarter,
         product_id,
         AVG(quantity_sold * sales_price) AS avg_revenue
FROM     sales
GROUP BY 1, 2


-- alternative for handling date: DATE_TRUNC('quarter', sale_date) AS quarter
```

---

### 7. Can you explain the purpose of the UNIQUE SQL constraint?

#### `Answer`:

The UNIQUE constraint makes sure that all values in a column are distinct. It is often paired with other constraints, like NOT NULL, to ensure that the data follows certain rules.

For example, say you were an analyst on the marketing team at Cisco, and had access to a database on marketing campaigns:

```sql
CREATE TABLE cisco_campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget DECIMAL(10,2) NOT NULL
);
```

In this example, the `UNIQUE` constraint is applied to the `"campaign_name"` field to ensure that each campaign has a unique name.

This helps to ensure the integrity of the data in the cisco_campaigns table and prevents errors that could occur if two campaigns had the same name.

---

### 8. Analyze Customer and Order Data

As a data analyst at Cisco, you have been given two tables - one contains customer data ('customer') and the other contains order data ('orders'). Write a SQL query to find the average order amount for each state.

Here's your data:

`customer` Example Input:

| customer_id | first_name | last_name | state      |
| ----------- | ---------- | --------- | ---------- |
| 1           | John       | Doe       | California |
| 2           | Jane       | Smith     | Texas      |
| 3           | Bob        | Johnson   | New York   |
| 4           | Alice      | Williams  | California |
| 5           | Charlie    | Brown     | Texas      |

`orders` Example Input:

| order_id | customer_id | order_amount |
| -------- | ----------- | ------------ |
| 1001     | 1           | 500          |
| 1002     | 2           | 300          |
| 1003     | 3           | 700          |
| 1004     | 4           | 800          |
| 1005     | 5           | 600          |

Your output should have the name of the state and the average order amount for that state.

Example Output:

| state      | avg_order_amount |
| ---------- | ---------------- |
| California | 650              |
| Texas      | 450              |
| New York   | 700              |

#### `Solution`:

```sql
SELECT   state, AVG(order_amount) AS avg_order_amount
FROM     customer c JOIN orders o USING(customer_id)
GROUP BY 1
```

---
