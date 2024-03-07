## 6 REAL Amazon SQL Interview Questions (Updated 2024)

![](https://api.datalemur.com/assets/74d0a619-2138-4e73-bd02-91d5c02d208e "Datalemur: Amazon SQL interview")

---


### 1. [ Write a SQL query to get the average review ratings for every product every month.](https://datalemur.com/questions/sql-avg-review-ratings)

Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month.

The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places.

Sort the output first by month and then by product ID.

`reviews` Example Input:

| review_id | user_id | submit_date         | product_id | stars |
| --------- | ------- | ------------------- | ---------- | ----- |
| 6171      | 123     | 06/08/2022 00:00:00 | 50001      | 4     |
| 7802      | 265     | 06/10/2022 00:00:00 | 69852      | 4     |
| 5293      | 362     | 06/18/2022 00:00:00 | 50001      | 3     |
| 6352      | 192     | 07/26/2022 00:00:00 | 69852      | 3     |
| 4517      | 981     | 07/05/2022 00:00:00 | 69852      | 2     |

Example Output:

| mth | product | avg_stars |
| --- | ------- | --------- |
| 6   | 50001   | 3.50      |
| 6   | 69852   | 4.00      |
| 7   | 69852   | 2.50      |

#### `Solution`:

```sql
SELECT   EXTRACT(month FROM submit_date::DATE) as mth,
         product_id as product,
         ROUND(AVG(stars), 2) as avg_stars
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 2. Amazon databases are HUGE. How do you optimize a slow SQL query?

`Answer`:

- `SELECT` fields instead of using `SELECT *`

- Avoid `SELECT DISTINCT`

- Create joins with `INNER JOIN` (not `WHERE`)

- Avoid `JOINs` in general (maybe try de-normalization)

- Add indexes to your database

- Examine the SQL query execution plan

---

### 3. What are SQL constraints, and what are example constraints?

`Answer`:

Constraints are simply rules for what data goes into your database. Some SQL constraints are:

- `NOT NULL` - Stops NULL value from being inserted

- `UNIQUE` - Ensures unique values are inserted

- `INDEX` - Speeds up querying based on optimizing for a specific column that's often used to lookup records.

- `PRIMARY KEY` - Uniquely identifies each record

- `FOREIGN KEY` - Ensures referential integrity from on record to another in a different table

---

### 4. [Highest-Grossing Items](https://datalemur.com/questions/sql-highest-grossing)

Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month.

The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places.

Sort the output first by month and then by product ID.

`product_spend` **Example Input:**

| category    | product          | user_id | spend  | transaction_date    |
| ----------- | ---------------- | ------- | ------ | ------------------- |
| appliance   | refrigerator     | 165     | 246.00 | 12/26/2021 12:00:00 |
| appliance   | refrigerator     | 123     | 299.99 | 03/02/2022 12:00:00 |
| appliance   | washing machine  | 123     | 219.80 | 03/02/2022 12:00:00 |
| electronics | vacuum           | 178     | 152.00 | 04/05/2022 12:00:00 |
| electronics | wireless headset | 156     | 249.90 | 07/08/2022 12:00:00 |
| electronics | vacuum           | 145     | 189.00 | 07/15/2022 12:00:00 |

**Example Output:**

| category    | product          | total_spend |
| ----------- | ---------------- | ----------- |
| appliance   | refrigerator     | 299.99      |
| appliance   | washing machine  | 219.80      |
| electronics | vacuum           | 341.00      |
| electronics | wireless headset | 249.90      |

#### `Solution`:

```sql
WITH CTE as (
  SELECT   category,
           product,
           SUM(spend) as total_spend,
           RANK() OVER(PARTITION BY category ORDER BY SUM(spend) desc) as rank
  FROM     product_spend
  WHERE    EXTRACT(year from transaction_date)='2022'
  GROUP BY 1, 2
)
SELECT category, product, total_spend
FROM   CTE
WHERE  rank <=2
```

---

### 5. What's the difference between RANK() and DENSE_RANK()?

`Answer`:

Essentially `RANK` is to `SELECT` what dense_rank() is to SELECT DISTINCT.

`RANK()` gives you the ranking within your ordered partition. Ties have the same rank, with the next ranking(s) skipped. So, if you have 4 items at rank 2, the next rank listed would be ranked 6.

`DENSE_RANK()` also ranks within your ordered partition, BUT the ranks are consecutive. This means no ranks are skipped if there are ranks with multiple items, and the rank order depends on your `ORDER BY` clause.

---

### 6. Amazon Orders SQL Technical Assessment

This question about Amazon orders comes from a real Amazon Data Analyst SQL assessment. It’s a multi-part SQL question, similar to how take-home SQL challenges are structured, and asks increasingly more complex questions about the amazon orders.

`Amazon Orders Data`

Your given an orders table:

`ORDERS`

- order_id (composite primary key)

- customer_id (integer)

- order_datetime (timestamp)

- item_id (composite primary key)

- order_quantity (integer)

Here’s some sample data from `orders`:

| order_id | customer_id | order_datetime      | item_id | order_quantity |
| -------- | ----------- | ------------------- | ------- | -------------- |
| O-001    | 42489       | 2023-06-15 04:35:22 | C004    | 3              |
| O-005    | 11733       | 2023-01-12 11:48:35 | C005    | 1              |
| O-005    | 11733       | 2023-01-12 11:48:35 | C008    | 1              |
| O-006    | 83167       | 2023-01-16 02:52:07 | C012    | 2              |

You are also given an items table:

`ITEMS`

- item_id (pimary_key)

- item_category (string)

Here’s some sample data from `items`:

| item_id | item_category |
| ------- | ------------- |
| C004    | Books         |
| C005    | Books         |
| C006    | Apparel       |
| C007    | Electronics   |
| C008    | Electronics   |

`Amazon SQL Assessment Questions`

1. How many units were ordered yesterday? Hint: Yesterday’s date be found via the PostgreSQL snippet: `SELECT current_date - INTEGER '1' AS yesterday_date`

```sql
SELECT SUM(order_quantity) as total_units_ordered
FROM   Orders
WHERE  order_datetime >= (SELECT current_date - INTERVAL '1 DAY')and
       order_datetime < (SELECT current_date)
```

---

2. In the last 7 days (including today), how many units were ordered in each category? Hint: You need to consider ALL categories, even those with zero orders!

```sql
SELECT   i.item_category, COALESCE(SUM(o.order_quantity), 0) AS total_units
FROM     items i LEFT JOIN orders o ON i.item_id = o.item_id
                   AND o.order_datetime >= (SELECT current_date - INTERVAL '6 DAY')
GROUP BY 1
ORDER BY 2 DESC;
```

Remarks:

- `LEFT JOIN` to include all categories, even those with zero orders.

- `COALESCE` function is used to handle NULL values, replacing them with 0.

---

3. Write a query to get the earliest order_id for all customer for each date they placed an order. Hint: customers can place multiple orders on a single day!

```sql
WITH CTE AS (
    SELECT *, rank() over(partition by order_datetime::date order by order_id)
    FROM   orders
)
SELECT order_id as earliest_order_id
FROM   CTE
WHERE  rank=1
```

-- OR --

```sql
SELECT   customer_id, order_datetime::DATE, MIN(order_id) AS earliest_order_id
FROM     orders
GROUP BY 1, 2
ORDER BY 1, 2
```

4. Write a query to find the second earliest order_id for each customer for each date they placed two or more orders.

```sql
WITH cte AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY customer_id, order_datetime::date ORDER BY order_id) AS rank
    FROM orders
)
SELECT order_id AS second_earliest_order_id
FROM   cte
WHERE  rank = 2;
```
