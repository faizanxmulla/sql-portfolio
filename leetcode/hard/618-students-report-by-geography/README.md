<h2><a href="https://leetcode.com/problems/students-report-by-geography/description/\">Students Report By Geography</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' /><hr><p>Table: <code>Student</code></p>

<pre>
+---------+-----------+
| Column Name | Type    |
+---------+-----------+
| name    | varchar |
| continent | varchar |
+---------+-----------+
Each row of this table indicates the name of a student and the continent they are from.
</pre>


<p>A U.S graduate school has students from Asia, Europe, and America. The students' location information is stored in the table <code>Student</code> as below:</p>


<strong>Input:</strong> 

<pre>
+-------+----------+
| name  | continent|
+-------+----------+
| Jack  | America  |
| Pascal| Europe   |
| Xi    | Asia     |
| Jane  | America  |
+-------+----------+
</pre>

<p>Pivot the <code>continent</code> column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. 

The output headers should be America, Asia, and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.</p>

<p>&nbsp;</p>

<strong>Output:</strong> 

<pre>
+--------+-------+--------+
| America| Asia  | Europe |
+--------+-------+--------+
| Jack   | Xi    | Pascal |
| Jane   |       |        |
+--------+-------+--------+
</pre>
