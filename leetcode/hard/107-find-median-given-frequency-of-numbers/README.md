<h2><a href="https://leetcode.com/problems/find-median-given-frequency-of-numbers/description/">Find Median Given Frequency of Numbers</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p>Table: <code>Numbers</code></p>

<pre>
+----------+-------------+
| Number   | Frequency   |
+----------+-------------+
| int      | int         |
+----------+-------------+
Number is the primary key (column with unique values) for this table.
Each row of this table indicates the value of a number and its frequency.
</pre>

<p>&nbsp;</p>

<p>Write a solution to find the median of all numbers and name the result as median.</p>

<p>Return the result table <strong>in any order</strong>.</p>

<p>The&nbsp;result format is in the following example.</p>

<p>&nbsp;</p>
<p><strong class="example">Example 1:</strong></p>

<pre>
<strong>Input:</strong> 
Numbers table:
+----------+-------------+
| Number   | Frequency   |
+----------+-------------+
| 0        | 7           |
| 1        | 1           |
| 2        | 3           |
| 3        | 1           |

<strong>Output:</strong> 
+--------+
| median |
+--------+
| 0.0000 |

<strong>Explanation:</strong> 
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.
</pre>
