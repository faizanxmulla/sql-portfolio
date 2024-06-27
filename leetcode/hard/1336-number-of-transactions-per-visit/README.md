<h2><a href="https://leetcode.com/problems/number-of-transactions-per-visit/description/">Number of Transactions per Visit</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p><strong>Table:</strong> Visits</p>

<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| visit_date    | date    |
+---------------+---------+
(user_id, visit_date) is the primary key for this table.
Each row of this table indicates that user_id has visited the bank in visit_date.
</pre>

<p><strong>Table:</strong> Transactions</p>

<pre>
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| user_id          | int     |
| transaction_date | date    |
| amount           | int     |
+------------------+---------+

There is no primary key for this table, it may contain duplicates.
Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)

</pre>

<p>A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transactions in one visit.</p>

<p>Write an SQL query to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction and so on.</p>

<p>The result table will contain two columns:</p>

<ul>
  <li><code>transactions_count</code> which is the number of transactions done in one visit.</li>

  <li><code>visits_count</code> which is the corresponding number of users who did <code>transactions_count</code> in one visit to the bank.</li>
</ul>

<p><code>transactions_count</code> should take all values from 0 to max(<code>transactions_count</code>) done by one or more users.</p>

<p>Order the result table by <code>transactions_count</code>.</p>

<p>The query result format is in the following example:</p>

<pre>

<strong>Input:</strong> 

<strong>Visits table:</strong>
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-01-01 |
| 2       | 2020-01-02 |
| 12      | 2020-01-01 |
| 19      | 2020-01-03 |
| 1       | 2020-01-02 |
| 2       | 2020-01-03 |
| 1       | 2020-01-04 |
| 7       | 2020-01-11 |
| 9       | 2020-01-25 |
| 8       | 2020-01-28 |
+---------+------------+

<strong>Transactions table:</strong>

+---------+------------------+--------+
| user_id | transaction_date | amount |
+---------+------------------+--------+
| 1       | 2020-01-02       | 120    |
| 2       | 2020-01-03       | 22     |
| 7       | 2020-01-11       | 232    |
| 1       | 2020-01-04       | 7      |
| 9       | 2020-01-25       | 33     |
| 9       | 2020-01-25       | 66     |
| 8       | 2020-01-28       | 1      |
| 9       | 2020-01-25       | 99     |
+---------+------------------+--------+


<strong>Result table:</strong>

+--------------------+--------------+
| transactions_count | visits_count |
+--------------------+--------------+
| 0                  | 4            |
| 1                  | 5            |
| 2                  | 0            |
| 3                  | 1            |
+--------------------+--------------+

</pre>
<pre>

<strong>Explanation:</strong> 

* For transactions_count = 0, The visits (1, "2020-01-01"), (2, "2020-01-02"), (12, "2020-01-01") and (19, "2020-01-03") did no transactions so visits_count = 4.
* For transactions_count = 1, The visits (2, "2020-01-03"), (7, "2020-01-11"), (8, "2020-01-28"), (1, "2020-01-02") and (1, "2020-01-04") did one transaction so visits_count = 5.
* For transactions_count = 2, No customers visited the bank and did two transactions so visits_count = 0.
* For transactions_count = 3, The visit (9, "2020-01-25") did three transactions so visits_count = 1.
* For transactions_count >= 4, No customers visited the bank and did more than three transactions so we will stop at transactions_count = 3
