<h2><a href="https://leetcode.com/problems/count-salary-categories">Count Salary Categories</a></h2> <img src='https://img.shields.io/badge/Difficulty-Medium-orange' alt='Difficulty: Medium' /><hr><p>Table: <code>Accounts</code></p>

<pre>
+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.
</pre>

<p>&nbsp;</p>

<p>Write a solution&nbsp;to calculate the number of bank accounts for each salary category. The salary categories are:</p>

<ul>
	<li><code>&quot;Low Salary&quot;</code>: All the salaries <strong>strictly less</strong> than <code>$20000</code>.</li>
	<li><code>&quot;Average Salary&quot;</code>: All the salaries in the <strong>inclusive</strong> range <code>[$20000, $50000]</code>.</li>
	<li><code>&quot;High Salary&quot;</code>: All the salaries <strong>strictly greater</strong> than <code>$50000</code>.</li>
</ul>

<p>The result table <strong>must</strong> contain all three categories. If there are no accounts in a category,&nbsp;return&nbsp;<code>0</code>.</p>

<p>Return the result table in <strong>any order</strong>.</p>

<p>The&nbsp;result format is in the following example.</p>

<p>&nbsp;</p>
<p><strong class="example">Example 1:</strong></p>

<pre>
<strong>Input:</strong> 
Accounts table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
<strong>Output:</strong> 
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
<strong>Explanation:</strong> 
Low Salary: Account 2.
Average Salary: No accounts.
High Salary: Accounts 3, 6, and 8.
</pre>
