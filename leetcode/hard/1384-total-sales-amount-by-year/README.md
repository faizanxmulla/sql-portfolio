<h2><a href="https://leetcode.com/problems/total-sales-amount-by-year/description/">Total Sales Amount By Year</a></h2> <img src='https://img.shields.io/badge/Difficulty-Hard-red' alt='Difficulty: Hard' />

<hr>

<p>Table: <code>Product</code></p>

<pre>
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+

product_id is the primary key for this table.
product_name is the name of the product.
</pre>

<p>Table: <code>Sales</code></p>

<pre>
+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | varchar |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+

product_id is the primary key for this table.
period_start and period_end indicate the start and end date for the sales period, both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
</pre>


<p>Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name, and report_year.</p>
<p>Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.</p>
<p>The query result format is in the following example:</p>

<pre>

<strong>Input:</strong> 

Table: Product
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+


Table: Sales
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     | 2019        | 3500         |
| 2          | LC T-Shirt   | 2018        | 310          |
| 2          | LC T-Shirt   | 2019        | 3650         |
| 2          | LC T-Shirt   | 2020        | 10           |
| 3          | LC Keychain  | 2019        | 31           |
| 3          | LC Keychain  | 2020        | 31           |
+------------+--------------+-------------+--------------+
</pre>

<pre>

<strong>Explanation:</strong> 

- LC Phone was sold from 2019-01-25 to 2019-02-28, totaling 35 days in that period, resulting in a total amount of 35 * 100 = 3500.

- LC T-Shirt was sold from 2018-12-01 to 2020-01-01, with sales days totaling 31, 365, and 1 for the years 2018, 2019, and 2020 respectively.

- LC Keychain was sold from 2019-12-01 to 2020-01-31, with sales days totaling 31 and 31 for the years 2019 and 2020 respectively.
</pre>