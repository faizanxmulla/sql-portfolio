## 8 Crowdstrike SQL Interview Questions



### 1. Analyzing Threats Detected by CrowdStrike

CrowdStrike is a cybersecurity technology company. You are given a table named `threat_activity` which contains data about threats detected by CrowdStrike systems in various customer networks. 

Each row in the table represents a unique threat detected at a given time for a particular customer.

The columns in the table are as follows:

* `threat_id`: A unique identifier for the threat.

* `detect_time`: The time the threat was detected.
* `threat_type`: The category of the threat detected.  
* `customer_id`: The identifier for the customer in whose network the threat was detected.
* `location_id`: The identifier for the location where the threat was detected.

The task is to : **write a query that will show the total number of threats detected for each customer for every day, ranking each day by the number of threats detected.**

Here is some sample data for the problem:

`threat_activity` Example Input:

| threat_id | detect_time | threat_type | customer_id | location_id |
|-----------|-------------|-------------|-------------|-------------|
| 1 | 2022-06-01 00:00:00 | Malware | C123 | L789 |
| 2 | 2022-06-01 00:10:00 | Ransomware | C123 | L789 |
| 3 | 2022-06-02 00:12:00 | Phishing | C456 | L123 |
| 4 | 2022-06-02 00:15:00 | Malware | C456 | L123 |
| 5 | 2022-06-02 00:00:00 | Trojan | C123 | L789 |
| 6 | 2022-06-03 00:00:00 | Malware | C456 | L123 |

Example Output:

| date_detected | customer_id | total_threats | rank |
|---------------|-------------|----------------|------|
| 2022-06-01 | C123 | 2 | 1 |
| 2022-06-02 | C123 | 1 | 2 |
| 2022-06-02 | C456 | 2 | 1 |
| 2022-06-03 | C456 | 1 | 2 |


#### `Solution`:

```sql
SELECT   DATE(detect_time) as date_detected, 
		 customer_id, 
         COUNT(DISTINCT threat_id) as total_threats, 
         RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(DISTINCT threat_id) DESC) as ranks
FROM     threat_activity
GROUP BY 1, 2
```

---

### 2. Filter Customers based on Multiple Conditions for CrowdStrike

CrowdStrike has a database of customers who subscribe to its cybersecurity platform. Create a SQL statement that filters down this customer database to only show customers who have:

* An active subscription status

* A region of 'North America' OR 'Europe'
* Spend over $10,000 OR have more than 5 users in their account
* Do NOT have a 'Government' sector

Assume the 'customers' table schema as:

`customers` Example Input:

| customer_id | subscription_status | region | spend | user_count | sector |
|-------------|----------------------|--------|-------|------------|--------|
| 101 | Active | North America | 15000 | 3 | Private |
| 202 | Inactive | Europe | 5000 | 8 | Private |
| 303 | Active | Asia | 12000 | 6 | Government |
| 404 | Active | North America | 9500 | 4 | Public |
| 505 | Active | Europe | 11000 | 7 | Private |

Write a PostgreSQL query to solve this.


#### `Solution`:

```sql
SELECT *
FROM   customers
WHERE  subscription_status = 'Active' 
       AND (region IN ('North America', 'Europe') 
            AND (spend > 10000 OR user_count > 5) 
            AND sector != 'Government');
```

---


### 3. Can you explain the distinction between a unique and a non-unique index?

**Unique indexes** help ensure that there are no duplicate key values in a table, maintaining data integrity. They enforce uniqueness whenever keys are added or changed within the index.

**Non-unique indexes** on the other hand, are used to improve query performance by maintaining a sorted order of frequently used data values, but they do not enforce constraints on the associated table.

Unique Indexes are blazing fast. Non unique indexes can improve query performance, but they are often slower because of their non-unique nature.

----

### 4. Average Threat Level Reported by CrowdStrike

CrowdStrike, a cybersecurity technology firm, collects data on numerous threats it identifies each day. As part of its threat intelligence database, each row signifies a separate threat, where an associated numerical `threat_level` designates the threat's severity.

For each day, your task is to calculate the average `threat_level` of all threats identified. This will assist in gaining an understanding of the average seriousness of threats identified each day.

`threats` Example Input:

| threat_id | date_identified | threat_level |
|-----------|-----------------|--------------|
| 1 | 09/01/2022 | 7 |
| 2 | 09/01/2022 | 6 |
| 3 | 09/02/2022 | 8 |
| 4 | 09/03/2022 | 9 |
| 5 | 09/03/2022 | 5 |
| 6 | 09/03/2022 | 8 |
| 7 | 09/04/2022 | 7 |

Example Output:

| date_identified | avg_threat_level |
|-----------------|-------------------|
| 09/01/2022 | 6.50 |
| 09/02/2022 | 8.00 |
| 09/03/2022 | 7.33 |
| 09/04/2022 | 7.00 |


#### `Solution`:

```sql
SELECT   date_identified,
         AVG(threat_level) as avg_threat_level
FROM     threats
GROUP BY 1
```

---


### 5. Are NULLs handled the same as zero's and blank spaces in SQL?

NULLs are NOT the same as zero or blank spaces in SQL. NULLs are used to represent a missing value or the abscence of a value, whereas zero and blank space are legitimate values.

It's important to handle NULLs carefully, because they can mess up your analysis very easily. For example, if you compare a NULL value using the = operator, the result will always be NULL (because just like Drake, nothing be dared compared to NULL). That's why many data analysis in SQL start with removing NULLs using the `COALESCE()` function.


----

### 6. Customer Data Filter

CrowdStrike maintains a database of information about their customers. The following table shows an example data from the `customers` table:

`customers` Example Input:

| customer_id | first_name | last_name | email_domain |
|-------------|------------|-----------|--------------|
| 8945 | Maria | Miley | yahoo.com |
| 5455 | John | Stewart | gmail.com |
| 1166 | Robert | Jones | hotmail.com |
| 3685 | Patricia | Brown | crowdstrike.com |
| 7981 | James | Lopez | crowdstrike.com |

As part of a promotion targeted at employees of certain companies, CrowdStrike wishes to filter out customer records who have their `email_domain` registered as `crowdstrike.com`.

Can you write a PostgreSQL query to fetch information of customers whose email is registered with CrowdStrike?


#### `Solution`:

```sql
SELECT *
FROM   customers
WHERE  email_domain LIKE 'crowdstrike.com'
```

---


### 7. Could you provide a list of the join types in SQL and explain what each one does?

Joins in SQL allow you to combine data from different tables based on a shared key or set of keys.

Four JOIN types are available in SQL. For an example of each one, say you had sales data exported from CrowdStrike's Salesforce CRM stored in a PostgreSQL database, and had access to two tables: `sales` and `crowdstrike_customers`.

*   `INNER JOIN`: retrieves rows from both tables where there is a match in the shared key or keys. For example, an INNER JOIN between the Sales table and the Customers table would retrieve only the rows where the customer_id in the Sales table matches the customer_id in the `crowdstrike_customers` table.

*   `LEFT JOIN`: retrieves all rows from the left table (in this case, the sales table) and any matching rows from the right table (the `crowdstrike_customers` table). If there is no match in the right table, NULL values will be returned for the right table's columns.

*   `RIGHT JOIN`: retrieves all rows from the right table (in this case, the customers table) and any matching rows from the left table (the sales table). If there is no match in the left table, NULL values will be returned for the left table's columns.

*   `FULL OUTER JOIN`: retrieves all rows from both tables, regardless of whether there is a match in the shared key or keys. If there is no match, NULL values will be returned for the columns of the non-matching table.

----


### 8. Analyzing Customer Activities in CrowdStrike

You are a Data Analyst in CrowdStrike and your task is to analyze the customer database. You want to find out what software products are being used by each customer and also how much they use it; you also want to link this data with detailed information about the customer, like their location and their contact information.

For this purpose, you have two tables. 

The first table, `customers`, contains data related to the customers - specifically, `customer_id`, `name`, `email`, `country` and `city`. 

The second table, `software_usage`, stores data related to which customer uses which software product, including columns for `customer_id` (linked to the `customer_id` in the `customer` table), `software_product`, and `hours_used`.

`customers` Example Input:

| customer_id | name | email | country | city |
|-------------|------|-------|---------|------|
| 111 | John Doe | johndoe@example.com | USA | Los Angeles |
| 112 | Jane Smith | janesmith@example.com | Canada | Vancouver |
| 113 | Alois Alzheimer | alois@example.com | Germany | Berlin |
| 114 | Kain Tapper | kaintapper@example.com | Finland | Helsinki |
| 115 | Gregor Mendel | gregor@example.com | Czech Republic | Brno |

`software_usage` Example Input:

| usage_id | customer_id | software_product | hours_used |
|----------|-------------|-------------------|------------|
| 1 | 111 | Falcon Pro | 200 |
| 2 | 112 | Falcon Pro | 150 |
| 3 | 112 | Falcon Enterprise | 300 |
| 4 | 113 | Falcon Enterprise | 400 |
| 5 | 114 | Falcon Complete | 350 |
| 6 | 115 | Falcon Pro | 100 |
| 7 | 115 | Falcon Complete | 250 |


#### `Solution`:

```sql
SELECT c.customer_id, c.name, c.email, c.country, c.city, s.software_product, s.hours_used
FROM   customers c JOIN software_usage s USING(customer_id)
```

---