## 10 ServiceNow SQL Interview Questions

### 1. Calculate Average Ticket Resolve Time

As a data analyst at ServiceNow, you are asked to analyze the average time taken to resolve tickets in your company. You'll need to work with "tickets" table which contains ticket_id, status, created_at, and resolved_at columns. 

The status column indicates whether a particular ticket is resolved (value = 1) or not (value = 0). Resolved_at is NULL if the ticket is not resolved.  

**Calculate the average time taken to resolve tickets each day, and provide a running average across days using window functions.**

`tickets` **Example Input:**

| ticket_id | status | created_at          | resolved_at         |
|-----------|--------|----------------------|----------------------|
| T101      | 1      | 06/08/2022 09:10:00 | 06/08/2022 10:15:00 |
| T102      | 1      | 06/08/2022 09:30:00 | 06/08/2022 12:45:00 |
| T103      | 0      | 06/08/2022 10:00:00 | NULL                |
| T104      | 1      | 06/09/2022 08:00:00 | 06/09/2022 09:30:00 |
| T105      | 1      | 06/09/2022 09:20:00 | 06/09/2022 12:00:00 |

**Example Output:**

| date       | avg_resolve_time | running_avg |
|------------|-------------------|-------------|
| 2022-06-08 | 105               | 105         |
| 2022-06-09 | 135               | 120         |

**Answer:**

```sql
WITH resolve_times AS (
    SELECT   DATE(created_at) AS date, 
             AVG(EXTRACT(EPOCH FROM (resolved_at - created_at))/60) AS avg_resolve_time
    FROM     tickets
    WHERE    status = 1
    GROUP BY 1
)
SELECT   date, 
         avg_resolve_time,
         AVG(avg_resolve_time) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM     resolve_times
ORDER BY 1
```

---

### 2. Incident Report Processing

ServiceNow handles multiple incident reports every day. These reports come from multiple clients, and each client may submit multiple reports. Each incident report consists of a unique id, client id, date of submission, issue category, and status (open, in-progress, closed).

**Design a SQL query that calculates the number of unresolved (status: open or in-progress) incident reports per client for the last 30 days.**

`incident_reports` **Example Input**

| report_id | client_id | submission_date | category | status     |
|-----------|-----------|------------------|----------|------------|
| 201       | 101       | 09/13/2022       | hardware | open       |
| 204       | 102       | 09/16/2022       | software | in-progress|
| 215       | 101       | 09/20/2022       | network  | closed     |
| 223       | 103       | 09/25/2022       | software | open       |
| 231       | 102       | 09/30/2022       | hardware | closed     |

**Example Output:**

| client_id | unresolved_reports |
|-----------|-------------------|
| 101       | 1                 |
| 102       | 1                 |
| 103       | 1                 |

**Answer:**

```sql
SELECT   client_id, COUNT(report_id) AS report_count
FROM     incident_reports
WHERE    status IN ('open', 'in-progress') and 
		 submission_date >= CURRENT_DATE - INTERVAL '1 MONTH'
GROUP BY 1
```

---

### 3. What are the different types of database indexes?

**Answer:**

A database index is a data structure that improves the speed of data retrieval operations on a database table.

There are few different types of indexes that can be used in a database:

- **Primary index**: a unique identifier is used to access the row directly.

- **Unique index**: used to enforce the uniqueness of the indexed columns in a table.  
- **Composite index**: created on multiple columns of a table, is used to speed up the search process for multiple columns
- **Clustered index**: determines the physical order of the data in a table

For a concrete example, say you had a table of ServiceNow customer payments with the following columns:

- payment_id

- customer_id 
- payment_amount
- payment_date

Here's what a clustered index on the payment_date column would look like:

```sql
CREATE CLUSTERED INDEX payment_date_index ON servicenow_customer_payments (payment_date)
```

A clustered index on the payment_date column would determine the physical order of the records in the table based on the payment_date. This means that the records with the earliest payment_date values would be stored together physically in the table, followed by records with later payment_date values. 

This speeds up queries that filter or sort the data based on the payment_date, as the records are already physically sorted in the table.

---

### 4. Filter Service Incidents Based on Impact, Urgency and Status

ServiceNow is a platform for service management. In our company, we store data about customer-incidents in the "incidents" table. Each incident has a level of impact and urgency, both scored 1-3 where 1 is high and 3 is low. It also has the status: "New", "In Progress", "Resolved", or "Closed".

**Write a SQL query to retrieve all incidents which have high impact and urgency (score 1), and their status is either "In Progress" or "New".**

The incidents should be sorted by their creation date in ascending order.

**incidents Example Input:**

| incident_id | customer_id | created_date        | impact | urgency | status       |
|-------------|-------------|----------------------|--------|---------|--------------|
| 1001        | 50          | 06/01/2022 00:00:00 | 2      | 1       | "In Progress"|
| 1002        | 120         | 06/05/2022 00:00:00 | 1      | 1       | "New"        |
| 1003        | 90          | 06/06/2022 00:00:00 | 1      | 1       | "Resolved"   |
| 1004        | 200         | 06/10/2022 00:00:00 | 1      | 1       | "New"        |
| 1005        | 60          | 06/20/2022 00:00:00 | 3      | 1       | "In Progress"|

**Example Output:**

| incident_id | customer_id | created_date        | impact | urgency | status |
|-------------|-------------|----------------------|--------|---------|--------|
| 1002        | 120         | 06/05/2022 00:00:00 | 1      | 1       | "New"  |
| 1004        | 200         | 06/10/2022 00:00:00 | 1      | 1       | "New"  |

**Answer:**

```sql
SELECT   *
FROM     incidents
WHERE    impact = 1 AND urgency = 1 AND (status = 'In Progress' OR status = 'New')
ORDER BY created_date
```

---

### 5. Can you explain the purpose of the FOREIGN KEY constraint?

**Answer:**

A FOREIGN KEY is a field in a table that references the PRIMARY KEY of another table. It creates a link between the two tables and ensures that the data in the FOREIGN KEY field is valid.

Say for example you had sales analytics data from ServiceNow's CRM (customer-relationship management) tool.


```sql
CREATE TABLE opportunities (
    opportunity_id INTEGER PRIMARY KEY,
    opportunity_name VARCHAR(255) NOT NULL,
    account_id INTEGER NOT NULL,
    FOREIGN KEY (account_id) REFERENCES servicenow_accounts(account_id)
);
```

The FOREIGN KEY constraint ensures that the data in the account_id field of the "opportunities" table is valid, and prevents the insertion of rows in the opportunities table that do not have corresponding entries in the servicenow_accounts table. 

It also helps to enforce the relationship between the two tables and can be used to ensure that data is not deleted from the accounts table if there are still references to it in the opportunities` table.

---

### 6. Average Resolution Time of IT Tickets

In your role as a data analyst at ServiceNow, you've been tasked with examining the company's IT ticket system.

Each ticket has an opening and closing timestamp, and you've been asked to calculate the average resolution time for IT tickets created in each month of 2022.

Please provide your query using the following table as your data sample:

`tickets` **Example input:**

| ticket_id | start_time           | end_time             |
|-----------|----------------------|----------------------|
| 1         | 2022-01-01 09:00:00 | 2022-01-01 14:00:00 |
| 2         | 2022-01-02 12:00:00 | 2022-01-02 16:00:00 |
| 3         | 2022-02-01 09:00:00 | 2022-02-01 11:00:00 |
| 4         | 2022-02-02 18:00:00 | 2022-02-03 18:00:00 |
| 5         | 2022-03-01 06:00:00 | 2022-03-01 16:00:00 |

The start_time and end_time columns are both of timestamp type. The ticket_id column is an integer.

**Example Output:**

| month | avg_resolution_time_in_hours |
|-------|------------------------------|
| 1     | 4.50                         |
| 2     | 15.00                        |
| 3     | 10.00                        |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM start_time) as month, 
         AVG(EXTRACT(EPOCH FROM end_time - start_time) / 3600) as avg_resolution_time_in_hours
FROM     tickets
WHERE    EXTRACT(YEAR FROM start_time) = 2022
GROUP BY 1
ORDER BY 1
```

---

### 7. Can you list the various types of joins in SQL, and describe their purposes?

**Answer:**

Using a join in SQL, you can retrieve data from multiple tables and merge the results into a single table.

In SQL, there are four distinct types of JOINs. To demonstrate each kind, Imagine you had two database tables: an Advertising_Campaigns table that contains data on Google Ads keywords and their bid amounts, and a Sales table with information on product sales and the Google Ads keywords that drove those sales.

- **INNER JOIN**: An INNER JOIN retrieves rows from both tables where there is a match in the shared key or keys. For example, an INNER JOIN between the Advertising_Campaigns table and the Sales table could be performed using the keyword column as the shared key. This would retrieve only the rows where the keyword in the Advertising_Campaigns table matches the keyword in the Sales table.

- **LEFT JOIN**: A LEFT JOIN retrieves all rows from the left table (in this case, the Advertising_Campaigns table) and any matching rows from the right table (the Sales table). If there is no match in the right table, NULL values will be returned for the right table's columns.

- **RIGHT JOIN**: A RIGHT JOIN retrieves all rows from the right table (in this case, the Sales table) and any matching rows from the left table (the Advertising_Campaigns table). If there is no match in the left table, NULL values will be returned for the left table's columns.

- **FULL OUTER JOIN**: A FULL OUTER JOIN retrieves all rows from both tables, regardless of whether there is a match in the shared key or keys. If there is no match, NULL values will be returned for the columns of the non-matching table.

---

### 8. Analyzing Click-Through-Rates for ServiceNow

ServiceNow runs tons of enterprise marketing campaigns. Given a table of user interactions with their online ads, and another table of product purchases after clicking through the ads, let's calculate the click-through conversion rates for each ad.

The conversion rate is calculated as the number of purchases after clicking an ad, divided by the number of clicks on the ad. We then multiply the result by 100 to get a percentage.

Here are the sample data tables:

`ad_clicks` **Example Input:**

| click_id | user_id | click_time          | ad_id |
|----------|---------|----------------------|-------|
| 1        | 123     | 06/08/2022 00:00:00 | 5000  |
| 2        | 165     | 06/08/2022 01:00:00 | 5001  |
| 3        | 235     | 06/08/2022 01:30:00 | 5001  |
| 4        | 125     | 06/08/2022 02:00:00 | 5000  |
| 5        | 189     | 06/08/2022 03:00:00 | 5001  |

`purchases` **Example Input:**

| purchase_id | user_id | purchase_time       | product_id |
|-------------|---------|----------------------|------------|
| 1           | 123     | 06/08/2022 00:05:00 | 2000       |
| 2           | 165     | 06/08/2022 01:10:00 | 2001       |
| 3           | 235     | 06/08/2022 01:35:00 | 2000       |
| 4           | 189     | 06/08/2022 03:05:00 | 2001       |
| 5           | 189     | 06/08/2022 03:05:00 | 2000       |

**Answer:**

```sql
WITH ad_clicks_count AS (
  SELECT   ad_id, COUNT(click_id) AS num_clicks
  FROM     ad_clicks
  GROUP BY 1
),
purchases_count AS (
  SELECT   ac.ad_id, COUNT(p.purchase_id) AS num_purchases
  FROM     ad_clicks ac JOIN purchases p USING(user_id)
  WHERE    p.purchase_time > ac.click_time
  GROUP BY 1
)
SELECT acc.ad_id, 
       100.0 * IFNULL(pc.num_purchases, 0) / acc.num_clicks AS conversion_rate
FROM   ad_clicks_count acc LEFT JOIN purchases_count pc USING(ad_id);
```

---

### 9. Search for Clients in a Particular Region

ServiceNow, as a software company, would likely have a database table storing information about their clients such as their client_id, name, email, phone, and region. 

Imagine we have a scenario where the marketing team is planning a region-specific campaign and wants to filter out all clients that belong to a specific region that starts with 'Cal'. 

**Create a PostgreSQL query that retrieves all records from the clients table where the region starts with 'Cal'.**

`clients` **Example Input:**

| client_id | name          | email                   | phone     | region      |
|-----------|---------------|-------------------------|------------|-------------|
| 101       | John Doe      | john.doe@example.com    | 123456789 | California  |
| 102       | Jane Smith    | jane.smith@example.com  | 234567890 | Texas       |
| 103       | Alice Johnson | alice.johnson@example.com | 345678901 | California |
| 104       | Bob Johnson   | bob.johnson@example.com | 456789012 | Calgary     |
| 105       | Charlie Brown | charlie.brown@example.com | 567890123 | Florida     |

**Example Output:**

| client_id | name          | email                   | phone     | region      |
|-----------|---------------|-------------------------|------------|-------------|
| 101       | John Doe      | john.doe@example.com    |
| 103       | Alice Johnson | alice.johnson@example.com | 345678901 | California |
| 104       | Bob Johnson   | bob.johnson@example.com | 456789012 | Calgary     |

**Answer:**

```sql
SELECT *
FROM   clients
WHERE  region LIKE 'Cal%';
```



---

### 10. Can you explain the difference between WHERE and HAVING?

**Answer:**

The `WHERE` clause is used to filter rows from the result set of a `SELECT`, `UPDATE`, or `DELETE` statement. It allows you to specify a condition that must be met for a row to be included in the result set.

The `HAVING` clause is used to filter groups created by the `GROUP BY` clause. It is similar to the `WHERE` clause, but it is used to specify conditions on the groups created by the `GROUP BY` clause, rather than on the individual rows of the table.

Say you were working on a social media analytics project for ServiceNow.

Here is an example of a SQL query that you might write which uses both the `WHERE` and `HAVING` clauses:

```sql
SELECT   platform, 
         SUM(impressions) AS total_impressions, 
         AVG(conversions) AS avg_conversions
FROM     servicenow_social_media_data
WHERE    date >= '2023-01-01' AND date < '2023-02-01'
GROUP BY 1
HAVING   SUM(impressions) > 5000 AND AVG(conversions) > 0.2;
```

This query retrieves the total impressions and average conversions for each platform in the servicenow_social_media_data table, `WHERE` the date of the campaign is in January 2023. 

The rows are grouped by platform and the `HAVING` clause filters the groups to include only those with more than 5000 impressions and an average conversion rate above 0.2.

---

