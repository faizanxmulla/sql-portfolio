## 11 Workday SQL Interview Questions


### 1. Calculating the Average Salary per Department Using Window Function  

Suppose you are a data analyst in Workday's Solutions Engineering & Implementation team, and have been tasked by a customer to analyze employee salaries. 

Your client wants to compare the average salaries of each department to have a better understanding of the payroll distribution. 

**Write a SQL query to calculate the average salary per department.**

`employee` **Example Input:**

employee_id | first_name | last_name | department | salary
-----|-----|-----|-----|-----
1756 | Jane | Smith | Engineering | 80000
2853 | John | Doe | HR | 60000 
6478 | Matt | Jones | Engineering | 90000
1923 | Sara | Davis | HR | 65000
5241 | Mike | Brown | Marketing | 70000
3852 | Julia | Johnson | Engineering | 85000

**Example Output:**

department | avg_salary
-----|-----
Engineering | 85000
HR | 62500
Marketing | 70000

**Answer:**

```sql
SELECT department, 
       AVG(salary) OVER (PARTITION BY department) as avg_salary_by_department
FROM   employee;
```

---

### 2. Employee Attendance Statistics

Workday is a company that provides human capital management, financial management applications, and workforce management applications. Given that, let's consider a scenario where they want to analyze employee attendance statistics. 

The HR department would like to have a report showing the total working days and the days with vacation for each employee for a given month. They have two tables employee and timesheets.

Here is their structure:

`employee` **Example Input:**

employee_id | first_name | last_name
-----|-----|-----
123 | Jane | Smith
456 | John | Doe
789 | Emily | Johnson

`timesheets` **Example Input:**

timesheet_id | employee_id | work_date | hours_worked | leave_status
-----|-----|-----|-----|-----
1 | 123 | 2022-06-01 | 8 | WORKED
2 | 123 | 2022-06-02 | 8 | WORKED
3 | 123 | 2022-06-03 | 0 | VACATION
4 | 456 | 2022-06-01 | 8 | WORKED  
5 | 456 | 2022-06-02 | 0 | VACATION
6 | 789 | 2022-06-01 | 8 | WORKED

**Provide a PostgreSQL query that will output a table with columns Employee Name, Month-Year, Total Working Days, Vacation Days.**

**Answer:**

```sql
SELECT   CONCAT(e.first_name, ' ', e.last_name) as employee_name,
         to_char(t.work_date, 'Mon-YYYY') as month_year,
         SUM(CASE WHEN t.leave_status = 'WORKED' THEN 1 ELSE 0 END) as total_working_days,
         SUM(CASE WHEN t.leave_status = 'VACATION' THEN 1 ELSE 0 END) as vacation_days
FROM     employee e JOIN timesheets t USING(employee_id)
GROUP BY 1, 2
ORDER BY 1, 2

-- we can also use: COUNT(*) FILTER() instead.
```

---

### 3. What is a cross-join, and when would you use one?

**Answer:**

A cross-join, also known as a cartesian join, is like a mad scientist's laboratory experiment gone wild. It takes two tables and mixes them together to create a crazy new table with every possible combination of rows from the original tables.

Here's an example:

```sql
SELECT products.name AS product, colors.name AS color
FROM products
CROSS JOIN colors;
```

If you have 20 products and 10 colors, that's 200 rows right there! Cross-joins are great for generating all possible combinations, but they can also create really big tables if you're not careful.

---

### 4. Average Employee Leave Days

As an HR analytics company, Workday might be interested in tracking how many leave days employees use per year, on average, to monitor employee wellness and understand the company's operations.

Given the employee and leave tables below, write a SQL query to find the average number of leave days taken per employee per year.

`employee` **Example Input:**

employee_id | first_name | last_name | start_date
-----|-----|-----|-----
1 | John | Doe | 2019-05-14
2 | Jane | Smith | 2020-01-01
3 | Sarah | Johnson | 2020-07-01
4 | James | Brown | 2021-01-01

`leave` **Example Input:**

leave_id | employee_id | leave_start_date | leave_end_date 
-----|-----|-----|-----
1 | 1 | 2020-05-18 | 2020-05-22
2 | 2 | 2021-08-01 | 2021-08-15
3 | 3 | 2021-12-20 | 2022-01-03
4 | 1 | 2021-05-17 | 2021-05-21
5 | 4 | 2022-01-15 | 2022-01-22

**Answer:**

```sql
SELECT   employee_id, 
		 EXTRACT(YEAR FROM leave_start_date) as year, 
		 ROUND(AVG(leave_end_date-leave_start_date) + 1) as leave_days
FROM     employee e JOIN leave l USING(employee_id)
GROUP BY 1, 2
ORDER BY 1

-- plus 1 to include the first day of leave.
```

---

### 5. Could you clarify the difference between a left and a right join?

**Answer:**

A join in SQL combines rows from two or more tables based on a shared column or set of columns. To demonstrate the difference between a LEFT JOIN and RIGHT JOIN, say you had a table of Workday orders and Workday customers.

LEFT JOIN: A LEFT JOIN retrieves all rows from the left table (in this case, the Orders table) and any matching rows from the right table (the Customers table). If there is no match in the right table, NULL values will be returned for the right table's columns.

RIGHT JOIN: A RIGHT JOIN retrieves all rows from the right table (in this case, the Customers table) and any matching rows from the left table (the Orders table). If there is no match in the left table, NULL values will be returned for the left table's columns.

---

### 6. Calculate the Click-through Conversion Rate for Workday's Digital Products  

Workday, a company providing enterprise cloud applications for human resources and finance, tracks every click a user does in their ecosystem. Specifically, they're interested in understanding the clickthrough conversion rate from the point a user views a digital product, to the point they add it to their cart. To perform this analysis, Workday has captured key data in two tables: 'view_logs' and 'add_to_cart_logs'.

The 'view_logs' table records whenever a user views a product, and has three columns: log_id (integer), user_id (integer), and product_id (integer).

Meanwhile, the 'add_to_cart_logs' table records whenever a user adds a product to their cart, and also has three columns: log_id (integer), user_id (integer), and product_id (integer).

**Write a PostgreSQL query that calculates the clickthrough conversion rate** (i.e., the number of users who added a product to their cart after viewing it divided by the total number of users who viewed the product) for each product.

`view_logs`**Example Input:**

log_id | user_id | product_id
-----|-----|-----
101 | 767 | 2309
102 | 292 | 2309
103 | 602 | 4821
104 | 499 | 3417
105 | 555 | 3417


`add_to_cart_logs`**Example Input:**

log_id | user_id | product_id
-----|-----|-----
501 | 767 | 2309
502 | 292 | 2309 
503 | 602 | 4821
504 | 555 | 3417
505 | 382 | 3920

**Answer:**

```sql
SELECT   v.product_id,
         COUNT(DISTINCT a.user_id)::float / COUNT(DISTINCT v.user_id) AS conversion_rate
FROM     view_logs v LEFT JOIN add_to_cart_logs a USING(user_id, product_id)
GROUP BY 1
```

---

### 7. What does the SQL keyword DISTINCT do?

**Answer:**

The DISTINCT keyword removes duplicates from a SELECT query. 

Suppose you had a table of Workday customers, and wanted to figure out which cities the customers lived in, but didn't want duplicate results.

`workday_customers` table:

name | city
-----|-----
Akash | SF
Brittany | NYC
Carlos | NYC
Diego | Seattle
Eva | SF
Faye | Seattle

You could write a query like this to filter out the repeated cities:

```sql
SELECT DISTINCT city 
FROM   workday_customers;
```

Your result would be:

city |
-----|
SF |
NYC |
Seattle |

---

### 8. Calculate the Total Payroll and Average Salary per Department

As a large Human Capital Management (HCM) company, Workday needs to keep track of all the employees, their salaries, and departments to manage the payroll better. As part of the analytics team, you've been tasked to **write a SQL query to calculate the total payroll and average salary per department in the organization**.

`employees` **Example Input:**

emp_id | department_id | salary
-----|-----|-----
1 | 100 | 1200
2 | 100 | 1000
3 | 200 | 1500
4 | 200 | 1300
5 | 300 | 1800

`departments` **Example Input:**

dept_id | dept_name
-----|-----
100 | Marketing
200 | Sales  
300 | Engineering

**Example Output:**

dept_name | total_payroll | avg_salary
-----|-----|-----
Marketing | 2200 | 1100
Sales | 2800 | 1400
Engineering | 1800 | 1800

**Answer:**

```sql
SELECT   d.dept_name,
         SUM(e.salary) AS total_payroll,
         AVG(e.salary) AS avg_salary
FROM     employees AS e JOIN departments AS d ON e.department_id = d.dept_id
GROUP BY 1
```

---

### 9. Find Employees by Department

As part of your role as a database manager at Workday, you need to find all the employees that work in a specific department based on a partial name match. 

The HR team often needs this information to quickly identify the relevant employees as part of ongoing staff management. You have access to the 'employees' table, with the following structure.

`employees`**Example Input:**

emp_id | first_name | last_name | join_date | department
-----|-----|-----|-----|-----
001 | John | Doe | 01/10/2021 | Software Engineering
002 | Jane | Smith | 03/12/2020 | Data Analysis
003 | David | Brown | 05/15/2019 | Software Engineering
004 | Sarah | Johnson | 07/21/2021 | Data Analysis
005 | Michael | Miller | 09/16/2020 | Human Resources

Write a SQL query that will return all employees that work in a department containing the word 'Software'?

**Answer:**

```sql
SELECT *
FROM   employees
WHERE  department LIKE '%Software%';
```

---

### 10. What does the SQL command UNION do?

**Answer:**

UNION is used to combine the output of multiple SELECT statements into one big result!

For a concrete example, say you were a Data Analyst supporting the Sales Analytics team at Workday, and data on potential sales leads lived in both Salesforce CRM and Hubspot. To write a query to analyze leads created after 2023 started, across both CRMs, you could use UNION in the following way:

```sql
SELECT email, job_title, company_id
FROM   workday_sfdc_leads
WHERE  created_at > '2023-01-01';

UNION

SELECT email, job_title, company_id
FROM   workday_hubspot_leads
WHERE  created_at > '2023-01-01'
```

---

### 11. Calculate Employee Bonus  

In Workday, the HR would like to calculate a bonus for employees based on their performances. If an employee has completed over 120 hours in a month, they will receive a 5% bonus. 

If they completed over 140 hours, they receive a 10% bonus. For other hours, the bonus is calculated as hours * rate * 0.01. 

Use the SQL functions ABS(), ROUND(), SQRT(), MOD(), POWER() to calculate the total bonus for each employee.

**Example Input:**

`employee_hours`:

employee_id | month | year | hours_worked
-----|-----|-----|-----
101 | 1 | 2022 | 125
102 | 1 | 2022 | 130
103 | 1 | 2022 | 145
101 | 2 | 2022 | 122
102 | 2 | 2022 | 140
103 | 2 | 2022 | 130

`employee_rates`:

employee_id | rate
-----|-----
101 | 20
102 | 25
103 | 30

**Expected Output:**

employee_id | month | year | bonus
-----|-----|-----|-----
101 | 1 | 2022 | 125
102 | 1 | 2022 | 162.5
103 | 1 | 2022 | 435
101 | 2 | 2022 | 122
102 | 2 | 2022 | 350
103 | 2 | 2022 | 195

**Answer:**

```sql
WITH hours_worked_cte as (
	SELECT   employee_id, month, SUM(hours_worked) as total_hours_worked
	FROM     employee_hours
	GROUP BY 1, 2
)
SELECT employee_id,
	   month,
	   CASE WHEN total_hours_worked > 120 then total_hours_worked*rate*0.05
       		WHEN total_hours_worked > 140 then total_hours_worked*rate*0.1
            ELSE total_hours_worked*rate*0.01
       END as bonus
FROM   hours_worked_cte hw JOIN employee_rates er USING(employee_id)
```

---