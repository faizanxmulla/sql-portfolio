<h2><a href="https://leetcode.com/problems/average-salary-departments-vs-company/description/">Average Salary Departments vs Company</a></h2>
<img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr>

<p>Given two tables as below, write a query to display the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.</p>

<p>Table: <code>salary</code></p>

<pre>
+-------------+------+------+
| Column Name | Type | Key  |
+-------------+------+------+
| id          | int  | PRI  |
| employee_id | int  |      |
| amount      | int  |      |
| pay_date    | date |      |
+-------------+------+------+
</pre>

<p>Table: <code>employee</code></p>

<pre>
+---------------+------+------+
| Column Name   | Type | Key  |
+---------------+------+------+
| employee_id   | int  | PRI  |
| department_id | int  |      |
+---------------+------+------+
</pre>

<pre>

<strong>Sample input:</strong>

Salary table:
+----+-------------+--------+------------+
| id | employee_id | amount | pay_date   |
+----+-------------+--------+------------+
| 1  | 1           | 9000   | 2017-03-31 |
| 2  | 2           | 6000   | 2017-03-31 |
| 3  | 3           | 10000  | 2017-03-31 |
| 4  | 1           | 7000   | 2017-02-28 |  
| 5  | 2           | 6000   | 2017-02-28 |
| 6  | 3           | 8000   | 2017-02-28 |
+----+-------------+--------+------------+

Employee table: 
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 2             |  
| 3           | 2             |
+-------------+---------------+


<strong>Output:</strong>

+------------+---------------+-------------+
| pay_month  | department_id | comparison  |
+------------+---------------+-------------+
| 2017-03    | 1             | higher      |
| 2017-03    | 2             | lower       |
| 2017-02    | 1             | same        | 
| 2017-02    | 2             | same        |
+------------+---------------+-------------+
</pre>

<pre>
<strong>Explanation:</strong> 

- In March, the company's average salary is (9000+6000+10000)/3 = 8333.33

- The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33.
  
- The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.

- With the same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.
</pre>