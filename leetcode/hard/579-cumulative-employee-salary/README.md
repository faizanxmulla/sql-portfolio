<h2><a href="https://leetcode.com/problems/find-cumulative-salary-of-an-employee/description/">Find Cumulative Salary of an Employee</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p>Table: <code>Employee</code></p>

<pre>
+------+-------+--------+
| Id   | Month | Salary |
+------+-------+--------+
| int  | int   | int    |
+------+-------+--------+
Id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID, month, and salary of an employee.
</pre>

<p>&nbsp;</p>

<p>A company wants to calculate the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.</p>

<p>Write a solution to get the cumulative sum of an employee's salary over the specified period.</p>

<p>Return the result table <strong>ordered by</strong> 'Id' ascending, and then by 'Month' descending.</p>

<p>The&nbsp;result format is in the following example.</p>

<p>&nbsp;</p>
<p><strong class="example">Example 1:</strong></p>

<pre>

<strong>Input:</strong> 

Employee table:

+----+-------+--------+
| Id | Month | Salary |
+----+-------+--------+
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 1  | 2     | 30     |
| 2  | 2     | 30     |
| 3  | 2     | 40     |
| 1  | 3     | 40     |
| 3  | 3     | 60     |
| 1  | 4     | 60     |
| 3  | 4     | 70     |

<strong>Output:</strong> 
+----+-------+--------+
| Id | Month | Salary |
+----+-------+--------+
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |

<strong>Explanation:</strong> 

- Employee '1' has 3 salary records for the following 3 months except the most recent month '4': salary 40 for month '3', 30 for month '2' and 20 for month '1'.
So the cumulative sum of salary of this employee over 3 months is 90(40+30+20), 50(30+20) and 20 respectively.

- Employee '2' only has one salary record (month '1') except its most recent month '2'.

- Employee '3' has two salary records except its most recent pay month '4': month '3' with 60 and month '2' with 40. So the cumulative salary is as follows.
</pre>

<p>&nbsp;</p>
