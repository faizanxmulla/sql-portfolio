# Reconstructed SQL Practice Questions

This repository contains SQL questions reconstructed by an AI language model based on provided query solutions from a [SQL prep resource](https://github.com/quantumudit/DataLemur-SQL-Challenges/tree/master). The original questions are not publicly available.

**Note:** These are not the verbatim original questions but an AI's interpretation of them based on the solutions. Any resemblance to the original premium content is coincidental.

The purpose is to provide additional SQL practice material, but these questions should `not` be considered a `substitute for the original premium content` or a `means to circumvent paid resources`.

**Disclaimer:** For educational purposes only. The maintainers do not claim ownership or affiliation with the original content.

---

## Table of Contents
| Question | Title | Solution |
| --- | --- | --- |
| 07 | [Fill Missing Client Data](#07---fill-missing-client-data) | [Solution](07-fill-missing-client-data.sql) |
| 08 | [Spotify Streaming History](#08---spotify-streaming-history) | [Solution](08-spotify-streaming-history.sql) |
| 09 | [Frequently Purchased Pairs](#09---frequently-purchased-pairs) | [Solution](09-frequently-purchased-pairs.sql) |
| 16 | [LinkedIn Power Creators - Part 2](#16---linkedin-power-creators---part-2) | [Solution](16-linkedin-power-creators-part2.sql) |
| 17 | [Unique Money Transfer Relationship](#17---unique-money-transfer-relationship) | [Solution](17-unique-money-transfer-relationship.sql) |
| 18 | [User Session Activity](#18---user-session-activity) | [Solution](18-user-session-activity.sql) |
| 19 | [First Transaction](#19---first-transaction) | [Solution](19-first-transaction.sql) |
| 20 | [Photoshop Revenue Analysis](#20---photoshop-revenue-analysis) | [Solution](20-photoshop-revenue-analysis.sql) |
| 21 | [Consulting Bench Time](#21---consulting-bench-time) | [Solution](21-consulting-bench-time.sql) |
| 22 | [Cumulative Purchases by Product Type](#22---cumulative-purchases-by-product-type) | [Solution](22-cumulative-purchases-by-product-type.sql) |
| 23 | [Invalid Search Results](#23---invalid-search-results) | [Solution](23-invalid-search-results.sql) |
| 24 | [Repeat Purchases on Multiple Days](#24---repeat-purchases-on-multiple-days) | [Solution](24-repeat-purchases-on-multiple-days.sql) |
| 25 | [Compensation Outliers](#25---compensation-outliers) | [Solution](25-compensation-outliers.sql) |

---

## Questions

### [07 - Fill Missing Client Data](https://datalemur.com/questions/fill-missing-product)


Assume you're given a table with information on products, including their product IDs, categories, and names. Some products may have a NULL value for their category.

Write a SQL query to retrieve the product ID, category, and name for each product. For products with a NULL category, replace the NULL value with the first non-NULL category within the same category group.

**Notes:**

- A category group is defined as a consecutive sequence of products with the same category.


### `products` Table

| Column Name | Type    |
| ----------- | ------- |
| product_id  | integer |
| category    | string  |
| name        | string  |

### `products` Example Input

| product_id | category      | name         |
| ---------- | ------------- | ------------ |
| 1          | 'Electronics' | 'Laptop'     |
| 2          | 'Electronics' | 'Tablet'     |
| 3          | NULL          | 'Headphones' |
| 4          | NULL          | 'Speakers'   |
| 5          | 'Furniture'   | 'Chair'      |
| 6          | 'Furniture'   | 'Table'      |
| 7          | NULL          | 'Lamp'       |

### Example Output

| product_id | category      | name         |
| ---------- | ------------- | ------------ |
| 1          | 'Electronics' | 'Laptop'     |
| 2          | 'Electronics' | 'Tablet'     |
| 3          | 'Electronics' | 'Headphones' |
| 4          | 'Electronics' | 'Speakers'   |
| 5          | 'Furniture'   | 'Chair'      |
| 6          | 'Furniture'   | 'Table'      |
| 7          | 'Furniture'   | 'Lamp'       |

**Explanation**

In the example output, the NULL categories for products 3 and 4 have been replaced with 'Electronics' since they belong to the same category group as products 1 and 2. 

Similarly, the NULL category for product 7 has been replaced with 'Furniture' since it belongs to the same category group as products 5 and 6.

The dataset you are querying against may have different input & output - **this is just an example**!

---

### [08 - Spotify Streaming History](https://datalemur.com/questions/spotify-streaming-history)


You are given two tables: `songs_history` and `songs_weekly`. The `songs_history` table contains the total number of plays for each song by each user. 

The `songs_weekly` table contains the number of plays for each song by each user, but only for the current week (up to '2022-08-04').

Write a SQL query to calculate the total number of plays for each song by each user, combining the data from both tables.

**Notes:**

- The output should include the `user_id`, `song_id`, and the total `song_plays` for each combination of user and song.
- Order the results by `song_plays` in descending order.

### `songs_history` Table

| Column Name | Type    |
| ----------- | ------- |
| user_id     | integer |
| song_id     | integer |
| song_plays  | integer |

### `songs_weekly` Table

| Column Name | Type     |
| ----------- | -------- |
| user_id     | integer  |
| song_id     | integer  |
| listen_time | datetime |

### Example Input

#### `songs_history`

| user_id | song_id | song_plays |
| ------- | ------- | ---------- |
| 1       | 1       | 10         |
| 1       | 2       | 5          |
| 2       | 1       | 20         |

#### `songs_weekly`

| user_id | song_id | listen_time           |
| ------- | ------- | --------------------- |
| 1       | 1       | '2022-08-01 10:00:00' |
| 1       | 1       | '2022-08-02 11:00:00' |
| 1       | 2       | '2022-08-03 12:00:00' |
| 2       | 1       | '2022-08-04 13:00:00' |

### Example Output

| user_id | song_id | song_plays |
| ------- | ------- | ---------- |
| 2       | 1       | 21         |
| 1       | 1       | 12         |
| 1       | 2       | 6          |

**Explanation**
For user 1 and song 1, the total plays are 10 (from `songs_history`) + 2 (from `songs_weekly`), which is 12.

For user 1 and song 2, the total plays are 5 (from `songs_history`) + 1 (from `songs_weekly`), which is 6.
For user 2 and song 1, the total plays are 20 (from `songs_history`) + 1 (from `songs_weekly`), which is 21.

The results are ordered by `song_plays` in descending order.

---

### [09 - Frequently Purchased Pairs](https://datalemur.com/questions/frequently-purchased-pairs)

Given two tables, `transactions` and `products`, write a SQL query to find the 3 most frequently purchased pairs of products in the same transaction.

**Notes:**

- A pair of products is defined as two distinct products purchased in the same transaction.

- Each pair should be counted only once, regardless of the order in which the products appear in the transaction.
- The output should include the product names of the two products in the pair, and the number of times the pair was purchased (`combo_num`).
- Order the results by `combo_num` in descending order.

### `transactions` Table

| Column Name    | Type    |
| -------------- | ------- |
| transaction_id | integer |
| product_id     | integer |

### `products` Table

| Column Name  | Type    |
| ------------ | ------- |
| product_id   | integer |
| product_name | string  |

### Example Input

#### `transactions`

| transaction_id | product_id |
| -------------- | ---------- |
| 1              | 1          |
| 1              | 2          |
| 2              | 1          |
| 2              | 3          |
| 3              | 2          |
| 3              | 3          |
| 4              | 1          |
| 4              | 2          |
| 4              | 3          |

#### `products`

| product_id | product_name |
| ---------- | ------------ |
| 1          | 'Product A'  |
| 2          | 'Product B'  |
| 3          | 'Product C'  |

### Example Output

| product1    | product2    | combo_num |
| ----------- | ----------- | --------- |
| 'Product A' | 'Product B' | 3         |
| 'Product B' | 'Product C' | 2         |
| 'Product A' | 'Product C' | 1         |

**Explanation**

- The pair 'Product A' and 'Product B' was purchased together in 3 transactions (1, 2, and 4).

- The pair 'Product B' and 'Product C' was purchased together in 2 transactions (3 and 4).
- The pair 'Product A' and 'Product C' was purchased together in 1 transaction (4).

The results are ordered by `combo_num` in descending order, and the top 3 pairs are returned.

---

### [16 - LinkedIn Power Creators - Part 2](https://datalemur.com/questions/linkedin-power-creators-part2)

You are given three tables: `employee_company`, `personal_profiles`, and `company_pages`. The `employee_company` table maps employees to the companies they work for. 

The `personal_profiles` table contains information about individuals' LinkedIn profiles, including their follower counts. 

The `company_pages` table contains information about companies' LinkedIn pages, including their follower counts.

Write a SQL query to find the profile IDs of individuals who have more followers than the company they work for, labeling them as "power creators."

**Notes:**

- If an individual works for multiple companies, consider the company with the maximum number of followers.
- Order the output by `profile_id` in ascending order.

### `employee_company` Table

| Column Name         | Type    |
| ------------------- | ------- |
| personal_profile_id | integer |
| company_id          | integer |

### `personal_profiles` Table

| Column Name | Type    |
| ----------- | ------- |
| profile_id  | integer |
| name        | string  |
| followers   | integer |

### `company_pages` Table

| Column Name | Type    |
| ----------- | ------- |
| company_id  | integer |
| name        | string  |
| followers   | integer |

### Example Input

#### `employee_company`

| personal_profile_id | company_id |
| ------------------- | ---------- |
| 1                   | 1          |
| 2                   | 1          |
| 3                   | 2          |
| 4                   | 2          |

#### `personal_profiles`

| profile_id | name    | followers |
| ---------- | ------- | --------- |
| 1          | 'John'  | 1000      |
| 2          | 'Jane'  | 2000      |
| 3          | 'Alex'  | 500       |
| 4          | 'Sarah' | 3000      |

#### `company_pages`

| company_id | name        | followers |
| ---------- | ----------- | --------- |
| 1          | 'Company A' | 1500      |
| 2          | 'Company B' | 2500      |

### Example Output

## profile_id

2
4

**Explanation**

- For personal profile 1 (John), the company they work for (Company A) has more followers than John (1500 > 1000), so John is not a power creator.

- For personal profile 2 (Jane), Jane has more followers than the company she works for (Company A), so Jane is a power creator.
- For personal profile 3 (Alex), the company they work for (Company B) has more followers than Alex (2500 > 500), so Alex is not a power creator.
- For personal profile 4 (Sarah), Sarah has more followers than the company she works for (Company B), so Sarah is a power creator.

The output includes the profile IDs 2 and 4, ordered in ascending order.

---

### [17 - Unique Money Transfer Relationship](https://datalemur.com/questions/money-transfer-relationships)


You are given a table `payments` that records payments made between users. Each row represents a payment made from a `payer_id` to a `recipient_id`. 

Write a SQL query to find the number of unique two-way relationships, where a two-way relationship is defined as a pair of users who have both made payments to each other.

**Notes:**

- A two-way relationship should be counted only once, regardless of the number of payments made between the pair of users.
- The output should be a single value representing the number of unique two-way relationships.

### `payments` Table

| Column Name  | Type    |
| ------------ | ------- |
| payer_id     | integer |
| recipient_id | integer |

### Example Input

#### `payments`

| payer_id | recipient_id |
| -------- | ------------ |
| 1        | 2            |
| 2        | 1            |
| 1        | 3            |
| 4        | 1            |
| 4        | 2            |
| 2        | 4            |

### Example Output

|unique_relationships|
|--|
|2|

**Explanation**
In the example input, there are two pairs of users who have made payments to each other:

- User 1 and User 2 (rows 1 and 2)
- User 2 and User 4 (rows 4 and 6)

The relationship between User 1 and User 3 is not considered a two-way relationship since User 3 did not make a payment to User 1.

Therefore, the output is 2, representing the number of unique two-way relationships.


---
### [18 - User Session Activity](https://datalemur.com/questions/user-session-activity)


You are given a table `sessions` that contains information about user sessions on a social media platform. Each session is classified as either 'mobile' or 'web' based on the device used. 

Write a SQL query to rank the user sessions by their total duration, partitioned by the session type ('mobile' or 'web'), for the month of January 2022.


### `sessions` Table
Column Name | Type
--- | ---
user_id | integer
session_type | string ('mobile', 'web')
duration | float
start_date | datetime

### Example Input

#### `sessions`
user_id | session_type | duration | start_date
--- | --- | --- | ---
1 | 'mobile' | 10.5 | '2022-01-15 12:00:00'
1 | 'web' | 5.0 | '2022-01-20 10:00:00'
2 | 'mobile' | 12.0 | '2022-01-05 08:00:00'
2 | 'web' | 8.0 | '2022-01-10 14:00:00'
3 | 'mobile' | 9.0 | '2022-01-25 16:00:00'
3 | 'web' | 6.0 | '2022-01-30 18:00:00'

### Example Output

user_id | session_type | ranking
--- | --- | ---
2 | 'mobile' | 1
3 | 'mobile' | 2
1 | 'mobile' | 3
2 | 'web' | 1
3 | 'web' | 2
1 | 'web' | 3

**Explanation**

For the 'mobile' session type:
- User 2 has the longest total duration of 12.0, so they are ranked 1.

- User 3 has the second-longest total duration of 9.0, so they are ranked 2.
- User 1 has the third-longest total duration of 10.5, so they are ranked 3.

For the 'web' session type:
- User 2 has the longest total duration of 8.0, so they are ranked 1.

- User 3 has the second-longest total duration of 6.0, so they are ranked 2.
- User 1 has the third-longest total duration of 5.0, so they are ranked 3.


---
### [19 - First Transaction](https://datalemur.com/questions/sql-first-transaction)


You are given a table `user_transactions` that contains information about transactions made by users, including the `user_id`, `spend` amount, and `transaction_date`. 

Write a SQL query to find the number of users who made their first transaction spending $50 or more.


### `user_transactions` Table
Column Name | Type
--- | ---
user_id | integer
spend | float
transaction_date | datetime

### Example Input:

#### `user_transactions`
user_id | spend | transaction_date
--- | --- | ---
1 | 100.0 | '2022-01-01 10:00:00'
1 | 20.0 | '2022-01-02 12:00:00'
2 | 40.0 | '2022-01-01 08:00:00'
2 | 60.0 | '2022-01-03 14:00:00'
3 | 80.0 | '2022-01-02 16:00:00'
3 | 30.0 | '2022-01-01 09:00:00'

### Example Output:
|users|
|---|
|2|

**Explanation**

In the example input:

- User 1 made their first transaction on '2022-01-01' with a spend of $100.0, which meets the criteria.

- User 2 made their first transaction on '2022-01-01' with a spend of $40.0, which does not meet the criteria.
- User 3 made their first transaction on '2022-01-01' with a spend of $30.0, which does not meet the criteria. Their second transaction on '2022-01-02' with a spend of $80.0 would meet the criteria, but we only consider the first transaction.

Therefore, the output is 2, representing the count of users (User 1 and User 3) who made their first transaction spending $50 or more.

---
### [20 - Photoshop Revenue Analysis](https://datalemur.com/questions/photoshop-revenue-analysis)


You are provided with a table `adobe_transactions` containing information about transactions made by customers on Adobe products. Each transaction includes the `customer_id`, `revenue`, and `product`. 

Write a SQL query to calculate the total revenue generated by customers on Adobe products excluding revenue from Photoshop. 


**adobe_transactions Table**
Column Name | Type
--- | ---
customer_id | integer
revenue | float
product | varchar

**Example Input**
#### `adobe_transactions`
customer_id | revenue | product
--- | --- | ---
1 | 100.0 | 'Illustrator'
1 | 150.0 | 'Photoshop'
2 | 200.0 | 'Illustrator'
3 | 50.0 | 'Photoshop'
3 | 70.0 | 'InDesign'
4 | 120.0 | 'Lightroom'
4 | 80.0 | 'Photoshop'

**Example Output**
customer_id | revenue
--- | ---
1 | 100.0
3 | 70.0

**Explanation**
In the given example input:
- Customer 1 has revenue of $100.0 from 'Illustrator' excluding revenue from 'Photoshop'.

- Customer 3 has revenue of $70.0 from 'InDesign' excluding revenue from 'Photoshop'.
- Customers 2 and 4 are excluded because they have not purchased 'Photoshop'.

Therefore, the output includes only the revenue generated by customers who have purchased 'Photoshop' at least once, excluding revenue from 'Photoshop'.

--- 

### [21 - Consulting Bench Time](https://datalemur.com/questions/consulting-bench-time)


You are provided with two tables: `staffing` and `consulting_engagements`, containing information about employees and their consulting engagements respectively. 

The `staffing` table includes `employee_id`, `job_id`, and a flag `is_consultant` indicating whether an employee is a consultant or not. 

The `consulting_engagements` table includes `job_id`, `start_date`, and `end_date` for each consulting engagement. 

Write a SQL query to calculate the number of bench days for each consultant employee. Bench days are calculated as the number of days in a year (365) minus the total non-bench days, where non-bench days are the duration of consulting engagements.

**Notes:**
- Non-bench days are calculated as the duration (inclusive) of consulting engagements for each consultant employee.



**Tables**

#### `staffing`
Column Name | Type
--- | ---
employee_id | integer
job_id | integer
is_consultant | boolean

#### `consulting_engagements`

Column Name | Type
--- | ---
job_id | integer
start_date | date
end_date | date

**Example Input**

#### `staffing`

employee_id | job_id | is_consultant
--- | --- | ---
1 | 101 | true
2 | 102 | true
3 | 103 | false

#### `consulting_engagements`

job_id | start_date | end_date
--- | --- | ---
101 | '2023-01-01' | '2023-03-15'
102 | '2023-04-01' | '2023-06-30'
103 | '2023-02-15' | '2023-05-10'

**Example Output**
employee_id | bench_days
--- | ---
1 | 184
2 | 265

**Explanation**
In the given example input:
- Employee 1 has a consulting engagement from '2023-01-01' to '2023-03-15', totaling 74 non-bench days. Therefore, the bench days for Employee 1 are 365 - 74 = 291.

- Employee 2 has a consulting engagement from '2023-04-01' to '2023-06-30', totaling 91 non-bench days. Therefore, the bench days for Employee 2 are 365 - 91 = 274.

- Employee 3 is excluded as they are not a consultant.

Therefore, the output provides the number of bench days for each consultant employee.



---


### [22 - Cumulative Purchases by Product Type](https://datalemur.com/questions/sql-purchasing-activity)

You are given a table `total_trans` containing information about product transactions, including `order_date`, `product_type`, and `quantity` purchased. 

Write a SQL query to calculate the cumulative quantity purchased for each product type over time, considering all transactions up to the current order date.

**Note:**

- The cumulative quantity purchased for a specific product type at a particular order date includes the total quantity purchased for that product type in all transactions up to and including that order date.

**`total_trans` Table**
Column Name | Type
--- | ---
order_date | date
product_type | varchar
quantity | integer

**Example Input**

#### `total_trans`
order_date | product_type | quantity
--- | --- | ---
'2023-01-01' | 'A' | 10
'2023-01-01' | 'B' | 5
'2023-01-05' | 'A' | 8
'2023-01-07' | 'B' | 3

**Example Output**

order_date | product_type | cum_purchased
--- | --- | ---
'2023-01-01' | 'A' | 10
'2023-01-01' | 'B' | 5
'2023-01-05' | 'A' | 18
'2023-01-07' | 'B' | 8

**Explanation**

In the given example input:
- On '2023-01-01', the cumulative quantity purchased for product type 'A' is 10 and for product type 'B' is 5.

- On '2023-01-05', the cumulative quantity purchased for product type 'A' becomes 10 (previous cumulative) + 8 = 18, and for product type 'B', it remains 5.
- On '2023-01-07', the cumulative quantity purchased for product type 'A' remains 18, and for product type 'B', it becomes 5 (previous cumulative) + 3 = 8.

Therefore, the output shows the cumulative quantity purchased for each product type at each order date.



---
### [23 - Invalid Search Results](https://datalemur.com/questions/invalid-search-pct)


You are provided with a table `search_category` containing details about searches conducted in different countries. Each record includes the `country`, the number of searches (`num_search`), and the percentage of invalid results (`invalid_result_pct`). 

Write a SQL query to calculate the total number of searches and the percentage of invalid searches for each country.

**Notes:**

- Exclude records where either the number of searches or the percentage of invalid results is NULL.

- Calculate the percentage of invalid searches as a percentage of total searches, rounded to two decimal places.

**`search_category` Table**
Column Name | Type
--- | ---
country | varchar
num_search | integer
invalid_result_pct | float

**Example Input**
#### `search_category`
country | num_search | invalid_result_pct
--- | --- | ---
'USA' | 1000 | 5.0
'Canada' | 1500 | 7.5
'USA' | 2000 | 4.0
'Canada' | 1200 | 6.0
'UK' | 800 | 3.5

**Example Output**
country | total_search | invalid_result_pct
--- | --- | ---
'USA' | 3000 | 4.33
'Canada' | 2700 | 6.33
'UK' | 800 | 3.5

**Explanation**
In the given example input:
- For the USA, the total number of searches is 3000, and the total number of invalid searches is 130.

- For Canada, the total number of searches is 2700, and the total number of invalid searches is 171.

- For the UK, the total number of searches is 800, and the total number of invalid searches is 28.

Therefore, the output displays the total number of searches and the percentage of invalid searches for each country.



---
### [24 - Repeat Purchases on Multiple Days](https://datalemur.com/questions/sql-repeat-purchases)


You are provided with a table `purchases` containing information about purchases made by users, including `user_id`, `product_id`, and `purchase_date`. 

Write a SQL query to count the number of users who made multiple purchases of the same product.


**`purchases` Table**
Column Name | Type
--- | ---
user_id | integer
product_id | integer
purchase_date | date

**Example Input**

#### `purchases`
user_id | product_id | purchase_date
--- | --- | ---
1 | 101 | '2023-01-01'
1 | 102 | '2023-01-05'
2 | 101 | '2023-01-02'
2 | 101 | '2023-01-03'
3 | 103 | '2023-01-01'
3 | 103 | '2023-01-02'

**Example Output**
|users_num|
|---|
1

**Explanation**

In the given example input:
- User 1 made purchases of two different products.

- User 2 made multiple purchases of the same product (product_id 101).
- User 3 made purchases of the same product (product_id 103), but only once.

Therefore, there is only one user (User 2) who made multiple purchases of the same product.


---
### [25 - Compensation Outliers](https://datalemur.com/questions/compensation-outliers)


You are provided with a table `employee_pay` containing information about employees, including `employee_id`, `salary`, and `title`. 

Write a SQL query to identify overpaid and underpaid employees based on their salary compared to the average salary for employees with the same title.

**Notes:**

- Calculate the average salary for employees with the same title.

- Identify employees as 'Overpaid' if their salary is more than twice the average salary for employees with the same title.
- Identify employees as 'Underpaid' if their salary is less than half the average salary for employees with the same title.
- Exclude employees whose salary falls within the range of half to double the average salary for employees with the same title.

**`employee_pay` Table**
Column Name | Type
--- | ---
employee_id | integer
salary | float
title | varchar

**Example Input**
#### `employee_pay`
employee_id | salary | title
--- | --- | ---
1 | 50000 | 'Developer'
2 | 60000 | 'Developer'
3 | 70000 | 'Manager'
4 | 45000 | 'Manager'
5 | 55000 | 'Developer'
6 | 80000 | 'Manager'

**Example Output**
employee_id | salary | status
--- | --- | ---
1 | 50000 | 'Near Average'
2 | 60000 | 'Near Average'
3 | 70000 | 'Overpaid'
4 | 45000 | 'Underpaid'
6 | 80000 | 'Overpaid'

**Explanation**

In the given example input:

- For the 'Developer' title, the average salary is (50000 + 60000 + 55000) / 3 = 55000.
  - Employee 1 has a salary of 50000, which is near the average.
  - Employee 2 has a salary of 60000, which is near the average.

- For the 'Manager' title, the average salary is (70000 + 45000 + 80000) / 3 = 65000.
  - Employee 3 has a salary of 70000, which is overpaid.


  - Employee 4 has a salary of 45000, which is underpaid.
  - Employee 6 has a salary of 80000, which is overpaid.

Therefore, the output lists employees identified as overpaid or underpaid based on their salary compared to the average salary for employees with the same title.

