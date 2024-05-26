## 10 Zomato SQL Interview Questions

### 1. Analyze Restaurant Ratings Over Time

As a data analyst for Zomato, you have been tasked with tracking the average ratings for each restaurant over time. The data you have been provided with includes individual reviews, with the reviewer's ID, the date of the review, the restaurant ID, and the rating.  

**Write a SQL query to find the average rating for each restaurant for each month.**

Only include restaurants with at least 2 reviews in a given month.

`reviews` **Example Input:**

| review_id | user_id | submit_date | restaurant_id | rating |
|-----------|---------|-------------|----------------|--------|
| 1001      | 501     | 2022-01-15  | 101            | 4      |
| 1002      | 502     | 2022-01-20  | 101            | 5      |
| 1003      | 503     | 2022-01-25  | 102            | 3      |
| 1004      | 504     | 2022-02-15  | 102            | 4      |
| 1005      | 505     | 2022-02-20  | 101            | 5      |
| 1006      | 506     | 2022-03-01  | 101            | 4      |
| 1007      | 507     | 2022-03-05  | 102            | 2      |

**Example Output:**

| month | restaurant_id | avg_rating |
|-------|----------------|------------|
| 1     | 101            | 4.50       |
| 2     | 101            | 5.00       |
| 3     | 101            | 4.00       |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM submit_date) AS month,
         restaurant_id,
         AVG(rating) as avg_rating
FROM     reviews
GROUP BY 1, 2
HAVING   COUNT(review_id) >= 2
ORDER BY 1, 2
```

---

### 2. Design a Database Schema for Zomato

Zomato is a popular food delivery app joining the worldwide trend. You are tasked to design and implement an SQL database for this company. In particular, you will need to model tables for restaurants, customers and orders.

- Restaurants have a unique ID, name, type of cuisine they serve, and their location.

- Customers have a unique ID, name, contact, and their address.

- Orders are made by customers to a restaurant and have a unique ID, the date the order was placed, the customer's ID, the restaurant's ID and the total cost.

The management team wants to know how many orders each restaurant has received in a given month for tracking.

Assume that we are interested in the data for the month of August, 2022.

`restaurants` **Example Input:**

| restaurant_id | restaurant_name | cuisine_type | location |
|---------------|-----------------|--------------|----------|
| 101           | Pasta Bella     | Italian      | Delhi    |
| 102           | Sushi Ya        | Japanese     | Gurgaon  |
| 103           | Burger King     | Fast Food    | Mumbai   |
| 104           | Saibei Express  | Chinese      | Pune     |

`customers` **Example Input:**

| customer_id | customer_name | contact     | address |
|-------------|----------------|--------------|---------|
| 201         | John Doe       | 9999999999  | Delhi   |
| 202         | Jane Doe       | 8888888888  | Gurgaon |
| 203         | Rob Stark      | 7777777777  | Mumbai  |
| 204         | Rachael Watson | 6666666666  | Pune    |

`orders` **Example Input:**

| order_id | order_date | customer_id | restaurant_id | total_order_cost |
|----------|------------|-------------|----------------|------------------|
| 1001     | 08/10/2022 | 201         | 101            | 500              |
| 1002     | 08/15/2022 | 202         | 102            | 650              |
| 1003     | 08/20/2022 | 203         | 103            | 450              |
| 1004     | 08/25/2022 | 204         | 104            | 550              |
| 1005     | 08/20/2022 | 201         | 103            | 600              |
| 1006     | 08/25/2022 | 202         | 102            | 500              |

**Answer:**

```sql
SELECT   r.restaurant_name, COUNT(o.order_id) AS order_count
FROM     restaurants r JOIN orders o USING(restaurant_id)
WHERE    DATE_PART('month', o.order_date::DATE) = 8 AND DATE_PART('year', o.order_date::DATE) = 2022 
GROUP BY 1
ORDER BY 2 DESC
```

---

### 3. What is the purpose of a primary key in a database?

A primary key is a column or group of columns that uniquely identifies a row in a table. For example, say you had a database of Zomato marketing campaigns data:

```sql
CREATE TABLE MarketingCampaigns (
    CampaignID INTEGER PRIMARY KEY,
    CampaignName VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(8,2)
);
```

In this Zomato example, the CampaignID column is the primary key of the MarketingCampaigns table. The PRIMARY KEY constraint ensures that no two rows have the same CampaignID. This helps to maintain the integrity of the data in the table by preventing duplicate rows.

---

### 4. Analyze Customer Behavior on Zomato

Given a database of Zomato customer behavior (orders and reviews), write a query to filter out customer records that meet the following conditions:

- Customers who have ordered more than 5 times in the last month

- Have given at least one 1-star review

- Their most ordered food item is 'Pizza'.

`Hint`: You can use WHERE, AND, OR and NOT in your SQL queries.

Below are the sample tables:

`orders` **Example Input:**

| order_id | customer_id | order_date | food_item |
|----------|-------------|------------|-----------|
| 1        | 1           | 08/05/2022 | Pizza     |
| 2        | 2           | 08/05/2022 | Burger    |
| 3        | 1           | 08/04/2022 | Pizza     |
| 4        | 1           | 08/01/2022 | Pizza     |
| 5        | 2           | 07/31/2022 | Pizza     |
| 6        | 1           | 07/31/2022 | Burger    |
| 7        | 1           | 07/27/2022 | Pizza     |
| 8        | 1           | 07/24/2022 | Pizza     |

`reviews` **Example Input:**

| review_id | customer_id | review_date | rating |
|-----------|-------------|-------------|--------|
| 1         | 1           | 08/04/2022  | 4      |
| 2         | 2           | 08/03/2022  | 3      |


**Answer:**

```sql
WITH recent_orders AS (
    SELECT   customer_id, COUNT(order_id) AS order_count
    FROM     orders
    WHERE    order_date >= CURRENT_DATE - INTERVAL '1 MONTH'
    GROUP BY 1
    HAVING   COUNT(order_id) > 5
),
one_star_reviews AS (
    SELECT DISTINCT customer_id
    FROM   reviews
    WHERE  rating = 1
),
most_ordered_item AS (
    SELECT   customer_id,
             food_item,
             COUNT(food_item) AS item_count,
             RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(food_item) DESC)
    FROM     orders
    GROUP BY 1, 2
)
SELECT r.customer_id
FROM   recent_orders r JOIN one_star_reviews o USING(customer_id)
                       JOIN most_ordered_item m USING(customer_id)
WHERE  m.rank = 1 AND m.food_item = 'Pizza';
```

---

### 5. Can you describe the concept of a database index and the various types of indexes?

A database index is a data structure that provides a quick lookup of data in a column or columns of a table.

There are several types of indexes that can be used in a database:

- **Primary index**: a unique identifier is used to access the row directly.

- **Unique index**: used to enforce the uniqueness of the indexed columns in a table.

- **Composite index**: created on multiple columns of a table, is used to speed up the search process for multiple columns

- **Clustered index**: determines the physical order of the data in a table


---

### 6. Calculate the average rating of restaurants in Zomato

You are given a database of restaurant ratings in Zomato, you must write a query that finds the average rating of every restaurant in the database for the previous month.

`ratings` **Example Input:**

| rating_id | submit_date          | restaurant_id | rating |
|-----------|-----------------------|----------------|--------|
| 101       | 08/01/2022 00:00:00  | R1001          | 4.5    |
| 102       | 08/02/2022 00:00:00  | R2002          | 5.0    |
| 103       | 08/30/2022 00:00:00  | R1001          | 3.5    |
| 104       | 08/25/2022 00:00:00  | R2002          | 4.0    |
| 105       | 08/29/2022 00:00:00  | R1001          | 4.0    |

**Example Output:**

| restaurant | avg_rating |
|------------|------------|
| R1001      | 4.0        |
| R2002      | 4.5        |

**Answer:**

```sql
SELECT   restaurant_id AS restaurant, 
         AVG(rating) AS avg_rating
FROM     ratings
WHERE    DATE_PART('month', submit_date) = DATE_PART('month', CURRENT_DATE - INTERVAL '1 month') and
         DATE_PART('year', submit_date) = DATE_PART('year', CURRENT_DATE - INTERVAL '1 month')
GROUP BY 1
```

---

### 7. What are the similarities and differences between a clustered index and non-clustered index?

Clustered indexes have a special characteristic in that the order of the rows in the database corresponds to the order of the rows in the index. This is why a table can only have one clustered index, but it can have multiple non-clustered indexes.  

The main difference between clustered and non-clustered indexes is that the database tries to maintain the order of the data in the database to match the order of the corresponding keys in the clustered index. This can improve query performance as it provides a linear-access path to the data stored in the database.

---

### 8. Calculate Click-through-rate for Zomato's Digital Ads

Zomato, as a food delivery and restaurant discovery platform, frequently runs digital ad campaigns to attract and engage users. One key performance metric it tracks is click-through-rate (CTR), defined as the number of users who clicked on an ad divided by the number of users who viewed the ad.

Provided are two tables, ad_views and ad_clicks. The table ad_views logs each time an ad is viewed by a user, and the table ad_clicks logs each time an ad is clicked by a user.

`ad_views` **Example Input**

| time_stamp           | user_id | ad_id |
|-----------------------|---------|-------|
| 01/15/2022 8:00:00   | 1012    | 40037 |
| 01/18/2022 19:10:00  | 7890    | 50941 |
| 02/04/2022 22:30:00  | 6543    | 50941 |
| 02/11/2022 13:00:00  | 1012    | 40037 |
| 02/15/2022 07:00:00  | 7890    | 50941 |

`ad_clicks` **Example Input**

| time_stamp           | user_id | ad_id |
|-----------------------|---------|-------|
| 01/18/2022 19:11:00  | 7890    | 50941 |
| 01/15/2022 8:01:00   | 1012    | 40037 |
| 02/15/2022 07:01:00  | 7890    | 50941 |
| 02/17/2022 8:00:00   | 1212    | 50941 |
| 02/11/2022 13:01:00  | 1012    | 40037 |

**Write an SQL query to find the click-through-rate on each ad.**

**Answer:**

```sql
SELECT v.ad_id, 
       (CAST(c.total_clicks AS FLOAT) / CAST(v.total_views AS FLOAT)) AS click_through_rate
FROM (
        SELECT   ad_id, COUNT(*) AS total_views 
        FROM     ad_views 
        GROUP BY 1
     ) AS v
LEFT JOIN (
        SELECT   ad_id, COUNT(*) AS total_clicks 
        FROM     ad_clicks 
        GROUP BY 1
     ) AS c
ON   v.ad_id = c.ad_id;
```


---

### 9.  Find the Most Popular Cuisine in Each City

Zomato, an online food order and delivery company, wants to keep track of the food preferences of its customers in various cities. The company wants to find out the most popular cuisine in each city based on the number of orders. 

**Write a SQL query to find out the most popular cuisine in each city using the order and restaurant information.**

Assume we have two tables - Orders and Restaurants.

`orders` **Example Input:**  

| order_id | user_id | order_date          | restaurant_id |
|----------|---------|----------------------|----------------|
| 1001     | 123     | 07/20/2022 00:00:00 | 2001           |
| 1002     | 256     | 07/25/2022 00:00:00 | 2002           |
| 1003     | 789     | 07/27/2022 00:00:00 | 2003           |
| 1004     | 456     | 08/01/2022 00:00:00 | 2004           |
| 1005     | 123     | 08/05/2022 00:00:00 | 2002           |

`restaurants` **Example Input:**

| restaurant_id | city   | cuisine_type |
|----------------|--------|--------------|
| 2001           | Delhi  | Italian      |
| 2002           | Delhi  | Chinese      |
| 2003           | Mumbai | Indian       |
| 2004           | Mumbai | Chinese      |
| 2002           | Delhi  | Chinese      |

**Example Output:**

| city   | most_popular_cuisine |
|--------|----------------------|
| Delhi  | Chinese              |
| Mumbai | Chinese              |

**Answer:**

```sql
WITH order_count_cte AS (
    SELECT   city,
             cuisine_type,
             COUNT(order_id) AS order_count
    FROM     orders o JOIN restaurants r USING(restaurant_id)
    GROUP BY 1, 2
),
ranked_cuisines AS (
    SELECT city,
           cuisine_type,
           order_count,
           RANK() OVER (PARTITION BY city ORDER BY order_count DESC)
    FROM   order_count_cte
)
SELECT city,
       cuisine_type AS most_popular_cuisine
FROM   ranked_cuisines
WHERE  rank=1
```

---

### 10. What is the purpose of the SQL constraint UNIQUE?

A UNIQUE constraint ensures that all values in a column are different. It is often used in conjunction with other constraints, such as NOT NULL, to ensure that the data meets certain conditions.

For example, if you had Zomato sales leads data stored in a database, here's some constraints you'd use:

```sql
CREATE TABLE zomato_leads (
    lead_id INTEGER PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL, 
    company VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255) NOT NULL UNIQUE
);
```


---