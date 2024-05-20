## 10 Netflix SQL Interview Questions

### 1. Identify VIP Users for Netflix

To better cater to its most dedicated users, Netflix would like to identify its "VIP users" - those who are most active in terms of the number of hours of content they watch. 

**Write a SQL query that will retrieve the top 10 users with the most watched hours in the last month.**

`users` **Example Input:**

| user_id | sign_up_date | subscription_type |
|---------|--------------|-------------------|
| 435     | 08/20/2020   | Standard          |
| 278     | 01/01/2021   | Premium           |
| 529     | 09/15/2021   | Basic             |
| 692     | 12/28/2021   | Standard          |
| 729     | 01/06/2022   | Premium           |


`watching_activity` **Example Input:**

| activity_id | user_id | date_time          | show_id | hours_watched |
|-------------|---------|--------------------|---------|--------------:|
| 10355       | 435     | 02/09/2022 12:30:00| 12001   |           2.5 |
| 14872       | 278     | 02/10/2022 14:15:00| 17285   |           1.2 |
| 12293       | 529     | 02/18/2022 21:10:00| 12001   |           4.3 |
| 16352       | 692     | 02/20/2022 19:00:00| 17285   |           3.7 |
| 17485       | 729     | 02/25/2022 16:45:00| 17285   |           1.9 |


**Answer:**

```sql
SELECT   u.user_id, SUM(wa.hours_watched) AS total_hours_watched
FROM     users u JOIN watching_activity wa USING(user_id)
WHERE    date_time BETWEEN DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month') AND 
                           DATE_TRUNC('month', CURRENT_DATE)
GROUP BY 1
ORDER BY 2 DESC
LIMIT    10;
```

---

### 2. Analyzing Ratings For Netflix Shows

Given a table of user ratings for Netflix shows, **calculate the average rating for each show within a given month.** 

Assume that there is a column for user id, show id, rating (out of 5 stars), and date of review. Order the results by month and then by average rating (descending order).

This is will provide an interesting insights into how show ratings fluctuate over time and which shows have garnered the most positive feedback.

`show_reviews` **Example Input:**

| review_id | user_id | review_date        | show_id | stars |
|-----------|---------|---------------------|---------|-------|
| 6171      | 123     | 06/08/2022 00:00:00 | 50001   | 4     |
| 7802      | 265     | 06/10/2022 00:00:00 | 69852   | 4     |
| 5293      | 362     | 06/18/2022 00:00:00 | 50001   | 3     |
| 6352      | 192     | 07/26/2022 00:00:00 | 69852   | 3     |
| 4517      | 981     | 07/05/2022 00:00:00 | 69852   | 2     |

**Example Output:**

| mth | show_id | avg_stars |
|-----|---------|----------:|
| 6   | 50001   |      3.50 |
| 6   | 69852   |      4.00 |
| 7   | 69852   |      2.50 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM review_date) as mth,
         show_id,
         AVG(stars) as avg_stars
FROM     show_reviews 
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
```

---

### 3. What does EXCEPT / MINUS SQL commands do?

The `MINUS/EXCEPT` operator is used to return all rows from the first `SELECT` statement that are not returned by the second `SELECT` statement.

Note that `EXCEPT` is available in PostgreSQL and SQL Server, while `MINUS` is available in MySQL and Oracle (but don't stress about knowing which DBMS supports what exact commands since the interviewers at Netflix should be lenient!).

Here's a PostgreSQL example of using `EXCEPT` to find all of Netflix's Facebook video ads with more than 10k views that aren't also being run on YouTube:

```sql
SELECT ad_creative_id
FROM netflix_facebook_ads
WHERE views > 10000 AND type=video

EXCEPT

SELECT ad_creative_id
FROM netflix_youtube_ads
```

If you want to retain duplicates, you can use the `EXCEPT ALL` operator instead of `EXCEPT`. The `EXCEPT ALL` operator will return all rows, including duplicates.

---

### 4. Filter Netflix Users Based on Viewing History and Subscription Status

You are given a database of Netflix's user viewing history and their current subscription status. 

**Write a SQL query to find all active customers who watched more than 10 episodes of a show called "Stranger Things" in the last 30 days.**

For this question, consider the following tables:

`users` **Example Input:**

| user_id | active |
|---------|--------|
| 1001    | true   |
| 1002    | false  |
| 1003    | true   |
| 1004    | true   |
| 1005    | false  |

`viewing_history` **Example Input:**

| user_id | show_id | episode_id | watch_date |
|---------|---------|------------|------------|
| 1001    | 2001    | 3001       | 2022-10-01 |
| 1001    | 2001    | 3002       | 2022-10-02 |
| 1001    | 2001    | 3003       | 2022-10-03 |
| 1002    | 2001    | 3001       | 2022-10-01 |
| 1002    | 2001    | 3002       | 2022-10-02 |
| 1003    | 2001    | 3001       | 2022-10-01 |
| 1003    | 2001    | 3002       | 2022-11-01 |
| 1003    | 2001    | 3003       | 2022-11-02 |
| 1004    | 2002    | 3004       | 2022-11-03 |

`shows` **Example Input:**

| show_id | show_name          |
|---------|---------------------|
| 2001    | "Stranger Things"   |
| 2002    | "Money Heist"       |

**Answer:**

```sql
SELECT  DISTINCT v.user_id
FROM    users u JOIN viewing_history v USING(user_id) 
                JOIN shows s USING(show_id)
WHERE    u.active = TRUE AND 
         s.show_name = 'Stranger Things' AND 
         v.watch_date >= NOW() - INTERVAL '30 days'
GROUP BY 1
HAVING   COUNT(DISTINCT episode_id) > 10
```

---


### 5. What does it mean to denormalize a database?

Denormalization is the process of modifying a database schema in a way that deviates from the typical rules of normalization (1NF, 2NF, 3NF, etc.).

Denormalization is often used to improve the performance of a database, particularly when it is being used for reporting and analytical purposes (rather than in an Online Transaction Processing (OLTP) manager).

By duplicating data, denormalization can reduce the number of expensive joins required to retrieve data, which can improve query performance. However, denormalization can also cause problems such as increased data redundancy and the need for more complex update and delete operations.


---

### 6. Filter and Match Customer's Viewing Records

As a data analyst at Netflix, you are asked to analyze the customer's viewing records. You confirmed that Netflix is especially interested in customers who have been continuously watching a particular genre - 'Documentary' over the last month.

The task is to **find the name and email of those customers who have viewed more than five 'Documentary' movies within the last month.**

'Documentary' could be a part of a broader genre category in the `genre` field (for example, 'Documentary, History'). Therefore, the matching pattern could occur anywhere within the string.

Use the `movies` and `customer` databases provided below:

`movies` **Example Input:**

| movie_id | title               | genre                    | release_year |
|----------|----------------------|--------------------------|--------------|
| 1265     | 'The Last Dance'     | 'Documentary, Sport'     | 2020         |
| 7821     | 'Tiger King'         | 'Documentary, Crime'     | 2020         |
| 3402     | 'Becoming'           | 'Documentary'            | 2020         |
| 5698     | 'Swift               | 'Documentary, Music'     | 2020         |
| 4169     | 'The Irishman'       | 'Biography, Crime, Drama'| 2019         |
| 2698     | 'Extraction'         | 'Action, Thriller'       | 2020         |

`customer` **Example Input:**

| user_id | name           | email                    | last_movie_watched | date_watched |
|---------|-----------------|--------------------------|-------------------|--------------|
| 361     | 'John Doe'      | 'johndoe@gmail.com'      | 1265               | '2021-08-03' |
| 124     | 'Jane Smith'    | 'janesmith@yahoo.com'    | 1265               | '2021-08-03' |
| 815     | 'Emily Clark'   | 'emilyclark@hotmail.com' | 7821               | '2021-08-03' |
| 634     | 'Robert Brown'  | 'robertbrown@gmail.com'  | 3402               | '2021-08-03' |
| 962     | 'Sarah Johnson' | 'sarahjohnson@gmail.com' | 5698               | '2021-08-03' |

**Answer:**

```sql
SELECT   c.name, c.email 
FROM     customer as c JOIN movies as m ON m.movie_id=c.last_movie_watched 
WHERE    m.genre LIKE '%Documentary%' AND c.date_watched > CURRENT_DATE - INTERVAL '1 month'
GROUP BY 1, 2
HAVING   COUNT(c.user_id) > 5;
```

---

### 7. Can you explain the concept of database normalization?

Database normalization is the process of breaking down a table into smaller and more specific tables and defining relationships between them via foreign keys. 

This minimizes redundancy, and creates a database that's more flexible, scalable, and easier to maintain. It also helps to ensure the integrity of the data by minimizing the risk of data inconsistencies and anomalies.

---

### 8. Analyzing Netflix User Behavior and Content Ratings

You're a Data Analyst at Netflix, you have been asked to analyze customer behavior and their content ratings. You have the following two tables:

- A `users` table that has information about users, their ID and their `subscription_starts`.

- A `reviews` table that has information about what content each user has reviewed and the score they gave.

**Write a SQL query to analyze the data and find the average rating for each content**, sorted by the average rating in descending order.


`users` **Example Input:**

| user_id | subscription_starts |
|---------|---------------------|
| 1       | 2018-01-01          |
| 2       | 2019-02-20          |
| 3       | 2017-07-14          |
| 4       | 2020-11-28          |
| 5       | 2018-04-24          |

`reviews` **Example Input:**

| review_id | user_id | date       | content_id | rating |
|-----------|---------|------------|------------|--------|
| 101       | 1       | 2022-06-08 | 1          | 4      |
| 202       | 2       | 2022-06-10 | 2          | 4      |
| 303       | 3       | 2022-06-18 | 1          | 3      |
| 404       | 1       | 2022-07-26 | 2          | 3      |
| 505       | 5       | 2022-07-05 | 1          | 2      |

**Answer:**

```sql
SELECT   r.content_id, AVG(r.rating) AS avg_rating
FROM     users u JOIN reviews r USING(user_id)
GROUP BY 1
ORDER BY 2 DESC
```

---

### 9. Calculate the Standard Deviation of Movie Ratings

Netflix wants to have a better understanding of how their ratings vary for each movie department. They want to **calculate the standard deviation of ratings** given to the movies of various departments.

The `standard deviation` is a measure of how spread out the ratings are. If the ratings are all close to the mean, the standard deviation is close to zero. If the ratings are spread out over a wider range, the standard deviation is larger.

The standard deviation is calculated by taking the square root of the variance. 

`Variance` is calculated as follows: the difference between each rating and the mean rating is squared, these squared differences are averaged, this produces the variance.

Utilize the ratings provided by users and apply SQL functions like `AVG()`, `POWER()`, `SQRT()` to compute the standard deviation.

Assuming you have a table named `movie_ratings` like below:

`movie_ratings` **Example Input:**

| movie_id | department_id | rating  |
|----------|----------------|--------|
| 1001     | 200            | 4      |
| 1002     | 200            | 5      |
| 1003     | 201            | 3      |
| 1004     | 202            | 2      |
| 1005     | 200            | 2      |
| 1006     | 202            | 5      |
| 1007     | 201            | 1      |
| 1008     | 202            | 4      |

**Answer:**

```sql
WITH CTE AS (
    SELECT department_id,
           rating,
           AVG(rating) OVER (PARTITION BY department_id) as avg_rating
    FROM   movie_ratings
)
SELECT   department_id,
         SQRT(AVG(POWER(rating - avg_rating, 2))) as std_dev
FROM     CTE
GROUP BY 1
```

---

### 10. What is a foreign key?

A `foreign key` is a column or group of columns in a table that refers to the primary key in another table. The foreign key constraint helps maintain referential integrity between the two tables.

For example, let's look at the Netflix sales database:

`netflix_sales`:

| order_id | product_id | customer_id | quantity |
|----------|------------|--------------|----------|
| 1        | 222        | 1            | 2        |
| 2        | 333        | 1            | 1        |
| 3        | 444        | 2            | 3        |
| 4        | 555        | 3            | 1        |

In this table, `product_id` and `customer_id` could both be foreign keys. They reference the primary keys of other tables, such as a `Products` table and a `Customers` table, respectively. 

This establishes a relationship between the `netflix_sales` table and the other tables, such that each row in the sales database corresponds to a specific product and a specific customer.

---