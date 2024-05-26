## 11 Pinterest SQL Interview Questions

### 1. User Concurrent Sessions

Assume you're given a table containing information about user sessions, including the start and end times of each session.

**Write a query to retrieve the user session(s) that occur concurrently with the other user sessions.**

Output the session ID and the number of concurrent user sessions, sorted in descending order.

Assumptions:

- Concurrent sessions are defined as sessions that overlap with each other. For instance, if session 1 starts before session 2, session 2's start time should fall either before or after session 1's end time.

- Sessions with identical start and end times should not be considered concurrent sessions.

`sessions` **Table:**

| Column Name | Type |
|-------------|------|
| session_id  | integer |
| start_time  | datetime |
| end_time    | datetime |

`sessions` **Example Input:**

session_id |  start_time   |        end_time |
--|--|--|
746382  |     01/02/2024 12:00:00 | 02/01/2024 16:48:00 |
143145  |     01/02/2024 14:25:00 | 02/01/2024 15:05:00 |
134514  |     01/02/2024 15:23:00 | 02/01/2024 18:15:00 |
242354  |     01/02/2024 21:34:00 | 03/01/2024 00:11:00 |
143256  |     01/06/2024 06:55:00 | 01/06/2024 09:05:00 |


**Example Output:**

| session_id | concurrent_sessions |
|------------|----------------------|
| 746382     | 2                    |
| 143256     | 1                    |

**Answer:**

```sql
SELECT   s1.session_id, 
	     COUNT(s2.session_id) FILTER(WHERE s2.start_time BETWEEN s1.start_time and s1.end_time OR 
                                           s1.start_time BETWEEN s2.start_time and s2.end_time) 
         AS concurrent_sessions
FROM     sessions s1 JOIN sessions s2 ON s1.session_id != s2.session_id
GROUP BY 1
ORDER BY 2 DESC


-- or -- 

SELECT   s1.session_id, 
         COUNT(s2.session_id) AS concurrent_sessions 
FROM     sessions AS s1 JOIN sessions AS s2 ON s1.session_id != s2.session_id
                                        AND (s2.start_time BETWEEN s1.start_time AND s1.end_time
                                        OR s1.start_time BETWEEN s2.start_time AND s2.end_time)
GROUP BY 1
ORDER BY 2 DESC;
```

---

### 2. Pinterest Image Pins Statistics

**Write a SQL query to find the average number of pins a user pins, and the difference between the current average pin count and the previous month average pin count for specific users.**

`pins` **Example Input:**


| pin_id | user_id | pin_date |
|--------|---------|----------|
| 7543   | 123     | 06/02/2024 |
| 9528   | 265     | 06/11/2024 |
| 7023   | 123     | 06/30/2024 |
| 9875   | 192     | 07/12/2024 |
| 3654   | 123     | 07/25/2024 |
| 7564   | 981     | 07/28/2024 |

**Example Output:**

| mth | user_id | avg_monthly_pin | pin_change |
|-----|---------|-----------------|------------|
| 6   | 123     | 2               | NULL       |
| 6   | 265     | 1               | NULL       |
| 7   | 123     | 1               | -1         |
| 7   | 192     | 1               | NULL       |
| 7   | 981     | 1               | NULL       |

**Answer:**

```sql
WITH pin_count_cte as (
	SELECT   EXTRACT(MONTH FROM pin_date) as month,
       		 user_id,
             COUNT(pin_id) as avg_monthly_pin
	FROM     pins
	GROUP BY 1, 2
	ORDER BY 1, 2
),
prev_month_pin_count_cte as (
  	SELECT  month, 
  			user_id, 
  			avg_monthly_pin, 
  			LAG(avg_monthly_pin) OVER(PARTITION BY user_id ORDER BY month) AS prev_month_pin_count
    FROM    pin_count_cte
)
SELECT   month,
         user_id,
         avg_monthly_pin,
         avg_monthly_pin - prev_month_pin_count AS pin_change
FROM     prev_month_pin_count_cte
ORDER BY 1, 2
```

---

### 3. Distinction between Cross Join and Natural Join

Cross join and natural join are like two sides of a coin in the world of SQL.

**Cross joins** is like the wild and reckless cousin who creates a giant new table by combining every row from table A with every row from table B, no questions asked, no common key needed.

**Natural joins** are like the more refined and selective cousin who only combines rows from multiple tables if they have something in common (i.e., common columns/keys).

While cross join doesn't discriminate and will create a massive table if given the chance, natural join is more selective and only returns a table with the number of rows equal to the number of matching rows in the input tables. So, choose your JOIN wisely!

---

### 4. Pinterest's Popular Boards

Pinterest users can create and share content in the form of personal "boards". Each board is categorized under a specific theme, such as "Home Decor" or "Travel".

**Write a SQL query to find the top 3 most popular boards in the "Home Decor" category.**

`users` **Example Input:**

| user_id | username |
|---------|----------|
| 101     | 'jane_doe' |
| 102     | 'john_doe' |
| 103     | 'doe_rayme' |

`boards` **Example Input:**

| board_id | user_id | category    | followers_count |
|----------|---------|-------------|-----------------|
| 2001     | 101     | 'Home Decor' | 500             |
| 2002     | 102     | 'Travel'    | 800             |
| 2003     | 101     | 'Cooking'   | 300             |
| 2004     | 103     | 'Home Decor' | 1000            |
| 2005     | 102     | 'Home Decor' | 700             |

**Answer:**

```sql
SELECT   username, board_id, followers_count
FROM     boards b JOIN users u USING(user_id)
WHERE    category = 'Home Decor'
ORDER BY 3 DESC
LIMIT    3  
```

---

### 5. Finding Records in One Table Not Present in Another

To find records in one table that aren't in another, you can use a LEFT JOIN and check for NULL values in the right-side table.

Here's an example using two tables, Pinterest employees and Pinterest managers:

```sql
SELECT *
FROM pinterest_employees
LEFT JOIN pinterest_managers 
ON pinterest_employees.id = pinterest_managers.id
WHERE pinterest_managers.id IS NULL;
```

This query returns all rows from Pinterest employees where there is no matching row in managers based on the id column.

You can also use the EXCEPT operator in PostgreSQL and Microsoft SQL Server to return the records that are in the first table but not in the second. Here is an example:

```sql
SELECT * FROM pinterest_employees
EXCEPT
SELECT * FROM pinterest_managers
```

This will return all rows from employees that are not in managers. The EXCEPT operator works by returning the rows that are returned by the first query, but not by the second.

---

### 6. Filter Pinterest Users Who Like Cooking

As a data analyst for Pinterest, we are interested in getting insight into our users' activity and interests.

For this reason, we would like to write a SQL query which lists all users who have pinned at least 5 objects in "Cooking" category and have not pinned any objects in "Gardening" category within the past 30 days.

`users` **Example Input:**

| user_id | username      | account_created_date |
|---------|---------------|----------------------|
| 001     | mary123       | 2021-01-21           |
| 002     | cookFan99     | 2019-05-15           |
| 003     | pinterestLover| 2018-09-01           |
| 004     | pinner        | 2024-01-30           |

`pins` **Example Input:**

| pin_id | user_id | category   | pinned_date |
|--------|---------|------------|-------------|
| 1001   | 001     | Cooking    | 2024-07-15  |
| 1002   | 001     | Cooking    | 2024-07-16  |
| 1003   | 001     | Cooking    | 2024-07-17  |
| 1004   | 002     | Gardening  | 2024-07-18  |
| 1005   | 001     | Cooking    | 2024-07-15  |
| 1006   | 001     | Cooking    | 2024-07-16  |
| 1007   | 001     | Gardening  | 2024-07-17  |
| 1008   | 003     | Cooking    | 2024-07-16  |

**Answer:**

```sql
WITH condition1_cte as (
    SELECT   user_id, COUNT(pin_id) as cooking_pin_count
    FROM     users u JOIN pins p USING(user_id)
    WHERE    category='Cooking' and pinned_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY 1
    HAVING   COUNT(pin_id) >= 5
),
condition2_cte as (
  	SELECT   user_id, COUNT(pin_id) as gardening_pin_count
	FROM     users u JOIN pins p USING(user_id)
    WHERE    category='Gardening' and pinned_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY 1
    HAVING   COUNT(pin_id) = 0
)
SELECT u.user_id, u.username
FROM   users u JOIN condition1_cte c1 USING(user_id)
WHERE NOT EXISTS (
    SELECT 1
    FROM   condition2_cte c2
    WHERE  c2.user_id = u.user_id
);

```

---

### 7.  Can you explain what a cross-join is and the purpose of using them?

A cross-join, also known as a cartesian join, is a JOIN that produces the cross-product of two tables. In a cross-join, each row from the first table is matched with every row from the second table, resulting in a new table with a row for each possible combination of rows from the two input tables.

Here's a cross-join query you could run:

```sql
SELECT customers.id AS customer_id, pinterest_products.id AS product_id
FROM customers
CROSS JOIN pinterest_products;
```

Cross-joins are useful for generating all possible combinations, but they can also create huge tables if you're not careful. For instance, if you had 10,000 potential customers and Pinterest had 500 different product SKUs, the resulting cross-join would have 5 million rows!

---

### 8. Average Number of Pins per board for a User

For Pinterest, we could consider a situation where we want to find the average number of pins places on each board by a specific user.

Given a `pins` table representing pins created by users and a `boards` table representing boards created by users, find out the average number of pins per board for a specific user.

`pins` **Example Input:**

| pin_id | user_id | board_id | pin_date            |
|--------|---------|----------|----------------------|
| 201    | 123     | 1        | 06/08/2024 00:00:00 |
| 231    | 123     | 1        | 06/10/2024 00:00:00 |
| 456    | 123     | 2        | 06/18/2024 00:00:00 |
| 789    | 123     | 2        | 07/26/2024 00:00:00 |
| 567    | 123     | 3        | 07/05/2024 00:00:00 |

`boards` **Example Input:**

| board_id | user_id | board_name |
|----------|---------|------------|
| 1        | 123     | Travel     |
| 2        | 123     | Recipes    |
| 3        | 123     | Fashion    |
| 4        | 789     | Travel     |
| 5        | 789     | Recipes    |

**Answer:**

```sql
WITH cte as (
    SELECT   board_id, p.user_id, COUNT(pin_id) as pin_count
    FROM     boards b JOIN pins p USING(board_id)
    WHERE    p.user_id='123'
    GROUP BY 1, 2
    ORDER BY 1, 2
)
SELECT   user_id, ROUND(AVG(pin_count), 2) as avg_pins_count
FROM     cte
GROUP BY 1

```

---

### 9. Analyze the Click Through Rates for Pinterest

You are a data analyst at Pinterest. The marketing department has asked you to analyze their digital ads. Specifically, they are interested in the click-through rates for each ad.

`ad_clicks` Table:

| click_id | user_id | ad_id | click_date |
|----------|---------|-------|------------|
| 2675     | 145     | 1002  | 07/10/2024 |
| 3826     | 265     | 1356  | 07/15/2024 |
| 1749     | 362     | 1002  | 07/20/2024 |
| 7032     | 654     | 1356  | 07/25/2024 |
| 8917     | 295     | 1258  | 07/30/2024 |

`ad_views` Table:

| view_id | user_id | ad_id | view_date  |
|---------|---------|-------|------------|
| 1937    | 145     | 1002  | 07/10/2024 |
| 5296    | 265     | 1356  | 07/15/2024 |
| 6123    | 362     | 1258  | 07/20/2024 |
| 9152    | 654     | 1002  | 07/25/2024 |
| 7134    | 295     | 1356  | 07/30/2024 |

**Compute the Click Through Rate (CTR) for each ad for the month of July 2024.** 

CTR is calculated by dividing the total number of clicks that an ad receives by the total number of views, then multiplying by 100.

**Answer:**

```sql
SELECT   ad_id, 100.0 * (COUNT(c.click_id) / COUNT(v.view_id)) as CTR
FROM     ad_clicks c JOIN ad_views v USING(user_id, ad_id)
WHERE    EXTRACT(MONTH FROM click_date) = 7 AND EXTRACT(YEAR FROM click_date) = 2024
GROUP BY 1

-- NOTE: not 100% sure about the solution.
```

---

### 10. Difference between BETWEEN and IN operators

`BETWEEN` is used to select rows that match a range of values, whereas the `IN` operator checks for values in a specified list of values.

For example, to find campaigns with between 500 and 10k in spend, you could use `BETWEEN`:

```sql
SELECT * 
FROM   pinterest_ad_campaigns
WHERE  spend BETWEEN 500 AND 10000;
```

To find ad campaigns that were run on Facebook and Google's Display Network, you could use `IN`:

```sql
SELECT * 
FROM   pinterest_ad_campaigns
WHERE  ad_platform IN ("fb", "google_display");
```

---

### 11. Filtering User Interactions on Pinterest Boards

Pinterest maintains a vast database of users, boards, and pin ideas. For this SQL question, we want to understand the user interactions in the context of our broad topics available on Pinterest.

**Write a SQL query that filters the user interaction records for the boards that are related to "Food" and "Diy" topics.**

Specifically, find all user interactions where the board name starts with "Food" or "Diy."

**User Interactions Example Input:**

| interaction_id | user_id | board_id | board_name      | interaction_date | interaction_type |
|----------------|---------|----------|-----------------|-------------------|------------------|
| 111            | 001     | 101      | Food_For_Health | 12/01/2024       | Pin              |
| 112            | 002     | 102      | DIY_Home_Decor  | 12/04/2024       | Like             |
| 113            | 003     | 103      | Exercise_Regimens | 12/08/2024      | Pin              |
| 114            | 004     | 104      | DIY_Gardening   | 12/12/2024       | Comment          |
| 115            | 005     | 105      | Food_Cake_Recipes | 12/15/2024      | Pin              |

**Answer:**

```sql
SELECT *
FROM   user_interactions
WHERE  board_name LIKE 'Food%' OR board_name LIKE 'Diy%';
```