<h2><a href="https://leetcode.com/problems/report-contiguous-dates/description/">Report Contiguous Dates</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p><strong>Table:</strong> Failed</p>

<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
Primary key for this table is fail_date.
Failed table contains the days of failed tasks.
</pre>

<p><strong>Table:</strong> Succeeded</p>

<pre>
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.
</pre>

<p>A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.</p>

<p>Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.</p>

<p>period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.</p>

<p>Order result by start_date.</p>

<p>The query result format is in the following example:</p>

<pre>
<strong>Input:</strong> 


<strong>Failed table:</strong>
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+

<strong>Succeeded table:</strong>
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+

<strong>Result table:</strong>
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+
</pre>

<pre>

<strong>Explanation:</strong> 

- The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
- From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
- From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
- From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded".
