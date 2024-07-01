<h2><a href="https://leetcode.com/problems/find-the-subtasks-that-did-not-execute/description/">Find the Subtasks that did not execute</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p>Table: <code>Tasks</code></p>

<pre>
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the primary key for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labelled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.
</pre>

<p>Table: <code>Executed</code></p>

<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the primary key for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.accepted.
</pre>

Write an SQL query to report the IDs of the missing subtasks for each `task_id`.

Return the result table in any order.

<pre>
<strong>Input:</strong>

Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+

Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+
</pre>

<pre>

<strong>Output:</strong>

Result table:

+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+

</pre>

<pre>
<strong>Explanation:</strong>


- Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.

- Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.

- Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.
Solution


</pre>
