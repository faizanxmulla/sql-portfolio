<h2><a href="https://leetcode.com/problems/median-employee-salary/description/">Median Employee Salary</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p>The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.</p>

<pre>
+-----+------------+--------+
| Id  | Company    | Salary |
+-----+------------+--------+
| 1   | A          | 2341   |
| 2   | A          | 341    |
| 3   | A          | 15     |
| 4   | A          | 15314  |
| 5   | A          | 451    |
| 6   | A          | 513    |
| 7   | B          | 15     |
| 8   | B          | 13     |
| 9   | B          | 1154   |
| 10  | B          | 1345   |
| 11  | B          | 1221   |
| 12  | B          | 234    |
| 13  | C          | 2345   |
| 14  | C          | 2645   |
| 15  | C          | 2645   |
| 16  | C          | 2652   |
| 17  | C          | 65     |
+-----+------------+--------+
</pre>

<p>Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.</p>

<p>The result should be ordered by Company.</p>

<p>The query result format is in the following example:</p>

<pre>
+-----+------------+--------+
| Id  | Company    | Salary |
+-----+------------+--------+
| 5   | A          | 451    |
| 6   | A          | 513    |
| 12  | B          | 234    |
| 9   | B          | 1154   |
| 14  | C          | 2645   |
+-----+------------+--------+
</pre>
