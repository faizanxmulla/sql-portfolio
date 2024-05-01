## 9 Zscaler SQL Interview Questions

### 1. Identify VIP Users For Zscaler Based on Usage

You are a data analyst at Zscaler, and are tasked with identifying the power users - users who use Zscaler's cloud security services most frequently. In other words, you are looking to identify users who have the highest number of log entries in the system within the last 30 days.

Assume that you have access to a user_logs table that logs each activity of every user, the table structure is as following:

`user_logs` **Example Input:**

log_id  | user_id |  date_time  |         activity |
--|--|--|--|
92811 |   523  |     06/08/2022 00:00:00 | Login  |   
89272 |   265  |     06/10/2022 00:00:00 | Login |
98232 |   362  |     06/18/2022 00:00:00 | Protection Update |
11752 |   523  |     07/26/2022 00:00:00 | Logout |
21562 |   981  |     07/05/2022 00:00:00 | Login |


In the user_logs table:
- `log_id` is a unique identifier for each log, 
    
- `user_id` is the unique identifier for each user, 
    
- `date_time` is the timestamp of the log (activity), and 
    
- `activity` indicates the type of activity made by the user.

**Write a SQL query to return the top 10 users with the most log entries in the last 30 days.**


**Answer:**

```sql
SELECT   user_id, COUNT(log_id) as log_entries_count
FROM     user_logs
WHERE    date_time > NOW() - INTERVAL '30 days'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    10
```

---

### 2. Analyzing Cyber Threats Data

You are provided with the history of all the cyber threats that have been detected by Zscaler's security solution. As part of our data quality analysis, we want some insight into the volume of threats detected per client per week. 

**Write a SQL query that will give us each client's weekly threat count and a running total of their threat count so far.**

`alerts` **Example Input:**

alert_id |  client_id |  alert_date |  threat_type |
--|--|--|--|
8392  |     1005 |       06/01/2022 |  Malware |
9124 |      1073 |       06/01/2022 |  Phishing |
3421 |      1005 |       06/08/2022 |  Malware |
6594 |      1073 |       06/08/2022 |  Phishing |
5976 |      1005 |       06/15/2022 |  Malware |
7135 |      1073 |       06/15/2022 |  Phishing |


**Expected Output:**

week_number |  client_id |  weekly_threats  | running_total |
--|--|--|--|
22 |           1005  |      1   |             1 |
22 |           1073  |      1   |             1 |
23 |           1005  |      1   |             2 |
23 |           1073  |      1    |            2 |
24 |           1005  |      1   |             3  |
24 |           1073  |      1     |           3 |


**Answer:**

```sql
WITH weekly_threats_cte as (
	SELECT   EXTRACT(WEEK FROM alert_date) as week_number, 
	         client_id,
             COUNT(alert_id) as weekly_threats
	FROM     alerts
	GROUP BY 1, 2
	ORDER BY 1, 2
)
SELECT *, SUM(weekly_threats) OVER(PARTITION BY client_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM   weekly_threats_cte


-- refer this link for more on ROWS clause: https://learnsql.com/blog/sql-window-functions-rows-clause/
```


---

### 3. What's the difference between a foreign and primary key?

**Answer:**

To clarify the distinction between a primary key and a foreign key, let's examine employee data from Zscaler's HR database:

`zscaler_employees`:

| employee_id| first_name | last_name  | manager_id |
--|--|--|--|
| 1          | Aubrey     | Graham     | 3          |
| 2          | Marshal    | Mathers    | 3          |  
| 3          | Dwayne     | Carter     | 4          |
| 4          | Shawn      | Carter     |            |



In this table, `employee_id` serves as the primary key. It uniquely identifies each employee and cannot be null.

`manager_id` functions as a foreign key, linking to the `employee_id` of the employee's manager. This establishes a relationship between Zscaler employees and their managers, allowing for easy querying to find an employee's manager or see which employees report to a specific manager.

The `zscaler_employees` table may also have multiple foreign keys that reference primary keys in other tables. For example, `department_id` and `location_id` foreign keys could be used to connect each employee to their respective department and location.

---

### 4. Customer Subscription Filtering


As a business analyst for Zscaler, you are tasked to identify the customer subscriptions that are due for renewal within the next 30 days. Zscaler is specifically interested in customers who have subscribed to either the 'ZIA' or the 'ZPA' services, and have a subscription status of either 'Active' or 'Pending Renewal'.

Assume the existence of a `subscriptions` table with the following sample data:

`subscriptions` **Example Input:**

subscription_id |  customer_id |  service_type |  start_date |  end_date |    status |
--|--|--|--|--|--|
4543  |            5641  |        ZIA  |          05/08/2021 |  05/08/2022 |  Active |
8756  |            4536 |         ZPA  |          09/10/2021 |  09/10/2022 |  Pending Renewal |
7985 |             3482 |         ZDX  |          11/12/2021 |  11/12/2022 |  Active |
3539  |            8491 |         ZIA  |          08/28/2022 |  08/28/2023 |  Pending Renewal |
3476 |             9362 |         ZPA   |         06/15/2022 |  06/15/2023 |  Active |


**Write a SQL query to filter the required data from the `subscriptions` table.**

**Answer:**

```sql
SELECT * 
FROM   subscriptions 
WHERE  ((status = 'Active' OR status = 'Pending Renewal') 
         AND (service_type = 'ZIA' OR service_type ='ZPA') 
         AND (end_date - CURRENT_DATE <= 30));
```


---


### 5. When doing database schema design, what's an example of two entities that have a one-to-one relationship? What about one-to-many relationship?

**Answer:**

In database schema design, a `one-to-one relationship` is when each entity is associated with only one instance of the other. 

For instance, a US citizen's relationship with their social-security number (SSN) is one-to-one because each citizen can only have one SSN, and each SSN belongs to one person.

A `one-to-many relationship`, on the other hand, is when one entity can be associated with multiple instances of the other entity. 

An example of this is the relationship between a person and their email addresses - one person can have multiple email addresses, but each email address only belongs to one person.

---

### 6. Finding Zscaler Customer Records  


Given a table named `purchases` containing records of customer transactions with Zscaler, you are tasked to find all the records where the email column contains 'yahoo'. 

Assume the `purchases` table has the following columns: `purchase_id`, `product_id`, `user_id`, `email`, `purchase_date`.

`purchases` **Example Input:**

purchase_id |  product_id  | user_id |  email |            purchase_date |
--|--|--|--|--|
5012  |        785  |        442  |     test@gmail.com |   03/28/2021  | 
2100  |        546  |        145  |     test@yahoo.com |   08/19/2021 |
2001  |        217  |        999  |     user@yahoo.com |   09/12/2021 |
3679  |        689  |        672 |     data@yahoo.com |   10/10/2021 |
2456  |        897  |        359  |     info@gmail.com |   11/20/2021 |


**Example Output:**

purchase_id |  product_id |  user_id |  email |            purchase_date |
--|--|--|--|--|
2100   |       546  |        145 |      test@yahoo.com |   08/19/2021 |
2001   |       217 |         999 |      user@yahoo.com |   09/12/2021  | 
3679   |       689  |        672 |      data@yahoo.com |   10/10/2021 |


**Answer:**
```sql
SELECT *
FROM   purchases
WHERE  email LIKE '%yahoo%';
```



---

### 7. What's a database view?

**Answer:**

Database views are virtual tables based on the results of a SQL `SELECT` statement. They're just like vanilla tables, except views allow you to create simplified versions of tables or hide sensitive data from certain users.  

In PostgreSQL, you can create a view by using the `CREATE VIEW` command. Here's an example for the `zscaler_customers` table:

```sql
CREATE VIEW view_name AS
SELECT column_1, column_2, column3 
FROM   zscaler_customers
WHERE  condition;
```

---

### 8. Calculating Average Monthly Power Usage
 
Given Zscaler is a global leader in cloud security, they use a large number of servers to manage their workload. Therefore, let's assume you have been provided with a dataset about the total power that the servers have consumed (in kWh) in different departments of the company for each day. 

Your task is to calculate the average monthly power used by the servers in each department and round it to the nearest integer. 

Additionally, you need to calculate the percentage difference in power usage between consecutive months.

`power_usage` **Example Input:**


date_id  |    department_id  | power_used |
--|--|--|
06/08/2022 |  1   |            500 |
06/10/2022 |  1   |            550 |
06/15/2022 |  2   |            700  | 
07/10/2022 |  1   |            450 |
07/12/2022 |  2   |            625 |


**Example Output:**

mth |  department_id |  avg_power_used |  percentage_diff |
--|--|--|--|
6  |   1 |              525   |           NULL |
6  |   2 |              700   |           NULL |
7  |   1  |             450   |           -14 |
7  |   2 |              625   |           -10.7   |


**Answer:**
```sql
WITH cte as (
	SELECT   EXTRACT(MONTH FROM date_id) as mth,
	         department_id, 
             ROUND(AVG(power_used)) as avg_power_used 
	FROM     power_usage
	GROUP BY 1, 2
)
SELECT mth,
	   department_id,
       avg_power_used,
	   ROUND(avg_power_used, 0) AS avg_power_used,
       ROUND((avg_power_used - LAG(avg_power_used) OVER (PARTITION BY department_id)) * 100 / 
              LAG(avg_power_used) OVER (PARTITION BY department_id), 1) AS percentage_diff
FROM   cte
```


---

### 9. Analyzing Monthly Data Traffic Usage  

Zscaler is a global cloud-based information security company. They provide internet security, web security, next generation firewalls, sandboxing, SSL inspection, antivirus, vulnerability management and granular control of user activity in cloud computing, mobile and Internet of things environments.

Suppose you're a data analyst at Zscaler and you're tasked to analyze the monthly data traffic usage of their customers. 

You have a table named `traffic` and you want to know the total data traffic that's utilized on a monthly basis for the year 2022.  

The `traffic` table has the following fields:

- `id` as integer (unique identifier)

- `customer_id` as integer  
- `date_time` as timestamp
- `data_used` as float

For the purpose of this question, `data_used` is measured in Gigabytes (GB).

`traffic` **Example Input:**

id |   customer_id |  date_time |           data_used |
--|--|--|--|
101 |  4356 |         01/05/2022 06:25:00 | 5.0 |
102 |  9812  |        01/23/2022 09:42:00 | 3.4 |
103 |  4356 |         02/05/2022 12:59:00 | 4.2 |
104 |  5021 |         02/18/2022 14:18:00  |5.0 |
105 |  9812 |         02/28/2022 08:25:00 | 3.0 |


**Expected Output:**

month |  total_data_used |
--|--|
1    |   8.4   |
2   |    12.2 |

**Find the total `data_traffic_used` on a monthly basis for year 2022.**


**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM date_time) as month, 
	     SUM(data_used) as total_data_used
FROM     traffic
WHERE    EXTRACT(YEAR FROM date_time)='2022'
GROUP BY 1
```

---
