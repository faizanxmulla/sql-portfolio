## 13 Google SQL Interview Questions


### 1. Identify Most Active Google Search Users

**Question:**

The Google Search team wants to identify their 'power users' or VIP users that perform a lot of search activities. These users are determined by those who have conducted more than 500 searches in the past month. 

**Write a SQL query to find user ids and number of searches in the last month for these power users.**

`users` **Example Input**:

| user_id | user_name |
|--------|-----------|
| 123    | Alice     |
| 265    | Bob       |
| 362    | Charlie   |
| 192    | David     |
| 981    | Eve       |

**Example Input** (searches):

| search_id | user_id | search_date |
|-----------|---------|-------------|
| 001       | 123     | 06/08/2024 00:00:00 |
| 002       | 265     | 06/10/2024 00:00:00 |
| 003       | 362     | 06/18/2024 00:00:00 |
| 004       | 192     | 07/26/2024 00:00:00 |
| 005       | 981     | 07/05/2024 00:00:00 |
| 006       | 123     | 06/08/2024 00:00:01 |
| 007       | 192     | 06/18/2024 00:00:01 |
| ... | ... | ... |
| 600       | 123     | 07/28/2024 00:00:00 |
| 601       | 123     | 07/29/2024 00:00:00 |

**Answer:**


```sql
SELECT   user_id, COUNT(search_id) as search_count
FROM     users u JOIN searches s USING(user_id)
WHERE    search_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 1
HAVING   COUNT(search_id) > 500
```

---

### 2. Odd & Even Measurements

**Question:**

Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

**Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns.**

`measurements` **Example Input**:

| measurement_id | measurement_value | measurement_time |
|----------------|-------------------|------------------|
| 131233 | 1109.51 | 07/10/2024 09:00:00 |
| 135211 | 1662.74 | 07/10/2024 11:00:00 |
| 523542 | 1246.24 | 07/10/2024 13:15:00 |
| 143562 | 1124.50 | 07/11/2024 15:00:00 |
| 346462 | 1234.14 | 07/11/2024 16:45:00 |

**Example Output:**

| measurement_day | odd_sum | even_sum |
|-----------------|---------|----------|
| 07/10/2024 00:00:00 | 2355.75 | 1662.74 |
| 07/11/2024 00:00:00 | 1124.50 | 1234.14 |

**Answer:**

```sql
WITH ranked_measurements AS (
  SELECT CAST(measurement_time AS DATE) AS measurement_day, 
         measurement_value, 
         ROW_NUMBER() OVER (PARTITION BY CAST(measurement_time AS DATE) ORDER BY measurement_time) AS measurement_num 
  FROM   measurements
) 
SELECT   measurement_day, 
         SUM(measurement_value) FILTER (WHERE measurement_num % 2 != 0) AS odd_sum, 
         SUM(measurement_value) FILTER (WHERE measurement_num % 2 = 0) AS even_sum 
FROM     ranked_measurements
GROUP BY 1
```

---

### 3. Google Maps Flagged UGC

**Question:**

As a Data Analyst on the Google Maps User Generated Content team, you and your Product Manager are investigating user-generated content (UGC) – photos and reviews that independent users upload to Google Maps.

**Write a query to determine which type of place (place_category) attracts the most UGC tagged as "off-topic".** 

In the case of a tie, show the output in ascending order of place_category.

`place_info` **Example Input**:

| place_id | place_name | place_category |
|----------|------------|----------------|
| 1 | Baar Baar | Restaurant |
| 2 | Rubirosa | Restaurant |
| 3 | Mr. Purple | Bar |
| 4 | La Caverna | Bar |

`maps_ugc_review` **Example Input**:

| content_id | place_id | content_tag |
|------------|----------|-------------|
| 101 | 1 | Off-topic |
| 110 | 2 | Misinformation |
| 153 | 2 | Off-topic |
| 176 | 3 | Harassment |
| 190 | 3 | Off-topic |

**Example Output:**

| off_topic_places |
|------------------|
| Restaurant       |

**Answer:**

```sql
WITH off_topic_cte as (
    SELECT   place_category, COUNT(content_tag) AS off_topic_tags
    FROM     maps_ugc_review mr JOIN place_info pi USING(place_id)
    WHERE    content_tag='Off-topic'
    GROUP BY 1
    ORDER BY 2 DESC, 1
    LIMIT    1
)
SELECT place_category as off_topic_places
FROM   off_topic_cte

```

---

### 4. Determine the Most Popular Google Search Category

For this scenario, assume that Google wants to analyze the top searched categories in their platform to optimize their search results. 

We have two tables, `searches` which has information about each search, and `categories` where every category ID is associated with a category name.


`searches` **Example Input**:

| search_id | user_id | search_date | category_id | query |
|-----------|---------|-------------|-------------|-------|
| 1001      | 7654    | 06/01/2024 00:00:00 | 3001 | "chicken recipe" |
| 1002      | 2346    | 06/02/2024 00:00:00 | 3001 | "vegan meal prep" |
| 1003      | 8765    | 06/03/2024 00:00:00 | 2001 | "google stocks" |
| 1004      | 9871    | 07/01/2024 00:00:00 | 1001 | "python tutorial" |
| 1005      | 8760    | 07/02/2024 00:00:00 | 2001 | "tesla stocks" |


`categories` **Example Input**:

| category_id | category_name |
|-------------|---------------|
| 1001        | "Programming Tutorials" |
| 2001        | "Stock Market" |
| 3001        | "Recipes" |
| 4001        | "Sports News" |


**Example Output:**

| category_name | month | total_searches |
|---------------|-------|----------------|
| "Programming Tutorials" | 07 | 1 |
| "Stock Market" | 06 | 1 |
| "Stock Market" | 07 | 1 |
| "Recipes" | 06 | 2 |


**Write a SQL query that gives the total count of searches made in each category by month for the available data in the year 2024?**



**Answer:**

```sql
SELECT   category_name,
         EXTRACT(MONTH FROM search_date) as month,
         COUNT(search_id) as total_searches
FROM     searches s JOIN categories c USING(category_id)
WHERE    EXTRACT(YEAR FROM search_date) = 2024
GROUP BY 1, 2
ORDER BY 2, 1
```

---

### 5. What is database denormalization?

**Answer:**

Denormalization is the process of modifying a database schema in a way that deviates from the typical rules of normalization (1NF, 2NF, 3NF, etc.).

Denormalization is often used to improve the performance of a database, particularly when it is being used for reporting and analytical purposes (rather than in an Online Transaction Processing (OLTP) manager).

By duplicating data, denormalization can reduce the number of expensive joins required to retrieve data, which can improve query performance. However, denormalization can also cause problems such as increased data redundancy and the need for more complex update and delete operations.

---

### 6. Filter Google Ads by Relevant Details

As a data analyst at Google, you are tasked with examining the Google Ads data for better ad placement and customer targeting. You are asked to retrieve all records of ads from the database that fall into the following conditions:

- The 'status' of the ad is 'active'.

- The 'impressions' is greater than 500,000.
- The ad 'last_updated' in the year 2024.

`ads` **Example Input**:

| ad_id | name | status | impressions | last_updated |
|-------|------|--------|-------------|--------------|
| 1234 | Google Phone | active | 600000 | 06/25/2024 12:00:00 |
| 5678 | Google Laptop | inactive | 800000 | 05/18/2024 12:00:00 |
| 9012 | Google App | active | 300000 | 04/02/2024 12:00:00 |
| 3456 | Google Cloud | active | 700000 | 08/12/2024 12:00:00 |
| 7890 | Google Mail | inactive | 550000 | 09/03/2024 12:00:00 |

**Answer:**

```sql
SELECT *
FROM   ads
WHERE  status='active' AND
	     impressions > 5000000 AND
       EXTRACT(YEAR FROM last_updated) = '2024'
```

---

### 7. What do stored procedures do?

Stored procedures are a lot like functions in programming. They're used to encapsulate and organize business logic into one unit of code, and they can accept multiple input parameters and return multiple output values.

For example, if you were a Data Analyst at Google working on a HR analytics project, you might create a stored procedure to calculate the average salary for a given department:

```sql
CREATE FUNCTION get_avg_salary(department_name TEXT)
RETURNS NUMERIC AS
$BODY$
BEGIN
  RETURN (SELECT AVG(salary) FROM google_employees WHERE department = department_name);
END;
$BODY$
LANGUAGE 'plpgsql';
```

To call this stored procedure and find the average salary for the Data Analytics department you'd write the following query:

```sql
SELECT get_avg_salary('Data Analytics');
```

---

### 8. Median Google Search Frequency

**Question:**

Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

**Write a query to report the median of searches made by a user. Round the median to one decimal point.**


**Answer** : 

```sql
WITH cte AS (
    SELECT   searches, GENERATE_SERIES(1, num_users)
    FROM     search_frequency
    ORDER BY 1
)
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY searches)
FROM   cte;
```

---

### 9. What do the EXCEPT / MINUS operators do, and can you give an example?

The MINUS/EXCEPT operator is used to remove to return all rows from the first SELECT statement that are not returned by the second SELECT statement.

Note that EXCEPT is available in PostgreSQL and SQL Server, while MINUS is available in MySQL and Oracle (but don't stress about knowing which DBMS supports what exact commands since the interviewers at Google should be lenient!).

---

### 10. Assessing Google Ad Click-Through and Conversion Rates

As a data analyst on Google Shopping, one of your tasks is to monitor the efficiency of various Google Shopping ads. 

Specifically, you are interested in the click-through rate (CTR) and conversion rate (each click that results in placing an item into the shopping cart).

**Write a SQL query to assess the click-through rate (CTR) and conversion rate for each ad.**

`ad_clicks` **Example Input**:

| ad_id | user_id | click_date |
|-------|---------|------------|
| 1001 | 123 | 06/08/2024 |
| 1002 | 265 | 06/10/2024 |
| 1001 | 362 | 06/18/2024 |
| 1003 | 192 | 07/26/2024 |
| 1002 | 981 | 07/05/2024 |


`cart_addition` **Example Input**:

| ad_id | user_id | cart_date |
|-------|---------|-----------|
| 1001 | 123 | 06/08/2024 |
| 1003 | 192 | 07/26/2024 |
| 1002 | 265 | 06/11/2024 |

**Answer:**

```sql
SELECT   a.ad_id,
         COUNT(DISTINCT a.user_id) AS total_clicks,
         COUNT(DISTINCT c.user_id) AS total_conversions,
         COUNT(DISTINCT c.user_id)*1.0 / COUNT(DISTINCT a.user_id) * 100.0 AS conversion_rate
FROM     ad_clicks a LEFT JOIN cart_addition c USING(user_id, ad_id)
GROUP BY 1
```

---

### 11. Google Ad Campaign Performance

As a data analyst on the advertiser solutions team at Google, your task is to analyze the performance of various ad campaigns running on Google AdWords for a F500 client. 

You were asked to **find the average cost per click (CPC) for each campaign and each ad group within those campaigns for the previous month.**

- `CPC` is calculated as the total cost of all clicks divided by the number of clicks.

For this task, you have been given access to the ad_clicks table which stores data about each click on the ads.

`ad_clicks` **Example Input**:

| click_id | date | campaign_id | ad_group_id | clicks | cost |
|----------|------|-------------|-------------|---------|-------|
| 4325 | 06/08/2024 | 1302 | 2001 | 50 | 100.00 |
| 4637 | 06/10/2024 | 1403 | 2002 | 65 | 130.00 |
| 4876 | 06/18/2024 | 1302 | 2001 | 70 | 140.00 |
|4531 |	07/05/2024 |	1604 |	3001 |	80 |	200.00 |
|4749 |	07/05/2024 |	1604 |	2002 |	75 |	180.0 |


**Example Output**:

campaign_id |	ad_group_id |	avg_CPC |
--|--|--|
1302 |	2001 |	2.4 |
1403 |	2002 |	2.0 |
1604 |	3001 |	2.50 |
1604 |	2002 |	2.4 |


**Answer:**

```sql
SELECT   campaign_id, ad_group_id, ROUND(SUM(cost)/SUM(clicks), 2) AS avg_CPC
FROM     ad_clicks
GROUP BY 1, 2
```

---

### 12. In database design, what do foreign keys do?

A foreign key is a column or group of columns in a table that refers to the primary key in another table. The foreign key constraint helps maintain referential integrity between the two tables.

---

### 13. Analyze Android In-App Purchases

As a data analyst at Google on the Android PlayStore team, you are tasked with providing insights into in-app purchases made via the PlayStore.

**Write a SQL query to get a list of customers along with their last purchase.**

The result should contain customer_id, first name, last name, product, and latest purchase date.


`customers` **Example Input**:

customer_id |	first_name |	last_name |	app |
--|--|--|--|
1 |	John |	Doe |	Tinder |
2 |	Jane |	Smith |	CandyCrush |
3 |	Jack |	Brown |	Fortnite |
4 |	Emily |	Johnson |	Uber |
5 |	Jake |	Kenny |	Google Music |


`purchases` **Example Input**:

purchase_id |	customer_id |	price |	date |
--|--|--|--|
101 |	1 |	79.99 |	2024-02-23 |
102 |	2 |	49.99 |	2024-03-18 |
103 |	3 |	89.99 |	2024-06-08 |
104 |	4 |	119.99 |	2024-07-05 |


**Answer:**

```sql
SELECT   c.*, 
         MAX(date) AS latest_purchase_date
FROM     customers c JOIN purchases p USING(customer_id)
GROUP BY 1, 2, 3, 4
```

---