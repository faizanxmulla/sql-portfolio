## 11 Airbnb SQL Interview Questions

### 1. Identify Power Users on Airbnb

For a company like Airbnb, power users might be those who have both hosted and rented apartments frequently in the past year. 

**Write a SQL query to find the user_id for users who have hosted at least 10 times and have stayed at other apartments at least 10 times in the past year.**

For simplicity, assume the current date is `2022-12-31`.

For this question, you can consider two hypothetical tables hosts and stays.  

`hosts` **Example Input:**

| host_id | user_id | host_date |
|---------|---------|-----------|
| 123     | 1       | 2022-06-08|
| 456     | 2       | 2022-07-10|
| 789     | 1       | 2022-06-18|  
| 495     | 2       | 2022-07-26|
| 450     | 1       | 2022-06-05|


`stays` **Example Input:**

| stay_id | user_id | stay_date |
|---------|---------|-----------|
| 108     | 1       | 2022-06-09|
| 220     | 2       | 2022-07-15| 
| 330     | 1       | 2022-06-20|
| 440     | 1       | 2022-07-25|
| 550     | 2       | 2022-06-10|

**Answer:**

```sql
WITH host_count AS (
    SELECT   user_id
    FROM     hosts
    WHERE    host_date >= '2022-01-01' AND host_date <= '2022-12-31'
    GROUP BY 1
    HAVING   COUNT(host_id) >= 10
),
stay_count AS (
    SELECT   user_id
    FROM     stays
    WHERE    stay_date >= '2022-01-01' AND stay_date <= '2022-12-31'
    GROUP BY 1
    HAVING   COUNT(stay_id) >= 10
)
SELECT user_id
FROM   host_count hc JOIN stay_count sc USING(user_id)
```

---

### 2. Analyzing Monthly Average Ratings of Airbnb Property Listings

Given the reviews table with columns: review_id, user_id, submit_date, listing_id, stars, **write a SQL query to get the average rating of each Airbnb property listing per month.**

The submit_date column represents when the review was submitted. 

The listing_id column represents the unique ID of the Airbnb property, and stars represents the rating given by the user where 1 is the lowest and 5 is the highest rating.

`reviews` **Example Input:**

| review_id | user_id | submit_date         | listing_id | stars |
|-----------|---------|----------------------|------------|-------|
| 6171      | 123     | 01/02/2022 00:00:00 | 50001      | 4     |
| 7802      | 265     | 01/15/2022 00:00:00 | 69852      | 4     |
| 5293      | 362     | 01/22/2022 00:00:00 | 50001      | 3     |
| 6352      | 192     | 02/05/2022 00:00:00 | 69852      | 3     |
| 4517      | 981     | 02/10/2022 00:00:00 | 69852      | 2     |


**Example Output:**

| mth | listing_id | avg_stars |
|-----|------------|-----------|
| 1   | 50001      | 3.50      |
| 1   | 69852      | 4.00      |  
| 2   | 69852      | 2.50      |

**Answer:**

```sql
SELECT   EXTRACT(MONTH from submit_date) as mth, 
         listing_id, 
         AVG(stars) as avg_stars
FROM     reviews
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 3. What does the keyword DISTINCT do?

The `DISTINCT` keyword removes duplicates from a `SELECT` query.

Suppose you had a table of Airbnb customers, and wanted to figure out which cities the customers lived in, but didn't want duplicate results.

`airbnb_customers` table:

| name     | city    |
|----------|---------|
| Akash    | SF      |
| Brittany | NYC     |
| Carlos   | NYC     |
| Diego    | Seattle |
| Eva      | SF      |
| Faye     | Seattle |

You could write a query like this to filter out the repeated cities:

```sql
SELECT DISTINCT city 
FROM   airbnb_customers;
```

Your result would be:

| city    |
|---------|
| SF      |
| NYC     |
| Seattle |

---

### 4. Retrieve Housing Data from Specific Cities

You're a data analyst at Airbnb and you've been tasked with retrieving housing data from specific cities. 

You want to **find all Airbnb listings in San Francisco and New York that have at least 10 reviews and an average rating equal to or above 4.5.**

Assume you have two tables: a listings table with the ID of the housing, its name, city, and the total number of reviews; and a reviews table with the ID of the listing, the review ID, the rating, and the date submitted.

`listings` **Example Input:**

| listing_id | name           | city          | reviews_count |
|------------|-----------------|---------------|---------------|
| 10001      | "Central Loft" | "San Francisco" | 15            |
| 10002      | "Cozy Apartment" | "New York"     | 20            |
| 10003      | "Sunny Studio"  | "San Francisco" | 8             |
| 10004      | "Stylish Suite" | "Las Vegas"    | 13            |
| 10005      | "Dreamy Duplex" | "New York"     | 5             |

`reviews` **Example Input:**  

| listing_id | review_id | stars | submit_date |
|------------|------------|-------|-------------|
| 10001      | 15001      | 4.5   | 2022-06-08  |
| 10001      | 15002      | 5.0   | 2022-06-10  |
| 10002      | 15003      | 4.0   | 2022-06-18  |
| 10002      | 15004      | 5.0   | 2022-07-26  |
| 10003      | 15005      | 3.5   | 2022-07-05  |
| 10004      | 15006      | 4.5   | 2022-06-08  |
| 10005      | 15007      | 3.0   | 2022-06-10  |

**Answer:**

```sql
SELECT   listing_id, name, city, AVG(stars) as avg_rating
FROM     listings l JOIN reviews r USING(listing_id)
WHERE    city in ('San Francisco', 'New York') AND 
         reviews_count >= 10
GROUP BY 1
HAVING   AVG(stars) >= 4.5;
```


---


### 5. What is the purpose of the SQL constraint UNIQUE?

The UNIQUE constraint is used to ensure the uniqueness of the data in a column or set of columns in a table. It prevents the insertion of duplicate values in the specified column or columns and helps to ensure the integrity and reliability of the data in the database.

For example, say you were on the Marketing Analytics team at Airbnb and were doing some automated keyword research:

Your keyword database might store SEO data like this:

```sql
CREATE TABLE keywords (
    keyword_id INTEGER PRIMARY KEY,
    keyword VARCHAR(255) NOT NULL UNIQUE,
    search_volume INTEGER NOT NULL,
    competition FLOAT NOT NULL
);
```

In this example, the UNIQUE constraint is applied to the "keyword" field to ensure that each keyword is unique. This helps to ensure the integrity of the data in the database and prevents errors that could occur if two rows had the same keyword.

---

### 6. Find the Average Number of Guests per Booking in Each City for Airbnb

As an analyst at Airbnb, one of the most useful insights you could provide would be to understand the average number of guests per booking across locations. For this question, we would like you to write a SQL query that will find the average number of guests per booking in each city.

`bookings` **Example Input:**

| booking_id | property_id | guests | booking_date |
|------------|--------------|--------|--------------|
| 101        | 4523         | 3      | 01/01/2022   |
| 102        | 9871         | 2      | 01/05/2022   |
| 103        | 4523         | 4      | 02/10/2022   |  
| 104        | 7452         | 1      | 02/20/2022   |
| 105        | 9871         | 3      | 03/01/2022   |

`properties` **Example Input:**

| property_id | city       |
|-------------|------------|
| 4523        | New York   |
| 9871        | Los Angeles|
| 7452        | Chicago    |

**Example Output:**

| city       | average_guests |
|------------|-----------------|
| New York   | 3.5            |
| Los Angeles| 2.5            |
| Chicago    | 1.0            |

**Answer:**

```sql
SELECT   p.city, AVG(b.guests) AS average_guests  
FROM     bookings b JOIN properties p USING(property_id)
GROUP BY 1
```


---

### 7. What's the difference between relational and non-relational databases?

While both types of databases are used to store data (no duh!), relational databases and non-relational (also known as NoSQL databases) differ in a few important ways, most importantly on the way data is stored. Relational databases use a data model consisting of tables and rows, while NoSQL databases use a variety of data models, including document, key-value, columnar, and graph storage formats.

This added flexibility makes NoSQL databases great for non-tabular data (like hierarchal data or JSON data), or data where the type/format is constantly evolving. With this added flexibility, comes one big weakness – you won't get ACID-compliance. That means, unlike relational databases which are typically adhere to the ACID properties (atomic, consistent, isolated, and durable), you don't get as strong guarantees with most non-relational databases.

---

### 8. Analyzing click-through rates for Airbnb Listing Views and Bookings

The scenario is that Airbnb wants to analyze the click-through conversion rates (CTRs) of their listings. 

The CTR is calculated by dividing the number of bookings by the number of listing views, giving a proportion of views that resulted in a booking.

Consider you have two tables: one showing all the views for a listing (listing_views) and another one showing all bookings (bookings).

`listing_views` **Example Input:**

| view_id | user_id | visit_date | listing_id |
|---------|---------|------------|------------|
| 101     | 10      | 7/08/2022  | 1001       |
| 102     | 12      | 7/08/2022  | 1002       |
| 103     | 14      | 7/09/2022  | 1001       |
| 104     | 10      | 7/10/2022  | 1003       |
| 105     | 13      | 7/11/2022  | 1002       |

`bookings` **Example Input:**

| booking_id | user_id | booking_date | listing_id |
|------------|---------|--------------|------------|
| 201        | 10      | 7/09/2022    | 1001       |
| 202        | 12      | 7/10/2022    | 1002       |
| 203        | 15      | 7/12/2022    | 1003       |
| 204        | 13      | 7/13/2022    | 1002       |
| 205        | 12      | 7/14/2022    | 1001       |

**Write a SQL query to find the CTR for every unique listing in July 2022.**

**Answer:**



```sql
WITH total_views AS (
    SELECT   listing_id, 
             COUNT(*) AS booking_count
    FROM     bookings
    WHERE    DATE_TRUNC('month', booking_date) = '2022-07-01'
    GROUP BY 1
),
total_bookings AS (
    SELECT   listing_id, 
             COUNT(*) AS booking_count
    FROM     bookings
    WHERE    DATE_TRUNC('month', booking_date) = '2022-07-01'
    GROUP BY 1
)
SELECT listing_id,  booking_count::decimal / NULLIF(V.view_count, 0) AS CTR
FROM   total_views v LEFT JOIN total_bookings b USING(listing_id);
```


---

### 9. The Most Popular City for Airbnb Stays

As a data analyst for Airbnb, you've been asked to determine the city that has had the most bookings (reservations) in the past year. You are given two tables - a 'bookings' table with booking IDs, user IDs, listing IDs, and booking dates, and a 'listings' table with listing IDs, city locations, and host IDs. 

**Provide a SQL query that returns the city with the maximum number of bookings, along with the number of bookings.**

`bookings` **Example Input:**

| booking_id | user_id | listing_id | booking_date |
|------------|---------|------------|--------------|
| 101        | 123     | 50001      | 06/08/2022   |
| 102        | 265     | 69852      | 06/10/2022   |
| 103        | 362     | 50001      | 06/18/2022   |
| 104        | 192     | 69852      | 07/26/2022   |
| 105        | 981     | 69852      | 07/05/2022   |



`listings` **Example Input:** 

| listing_id | city      | host_id |
|------------|-----------|---------|
| 50001      | Amsterdam | 876     |
| 69852      | Barcelona | 974     |

**Answer:**

```sql
SELECT   l.city, COUNT(b.booking_id) AS num_bookings
FROM     bookings b JOIN listings l USING(listing_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```


---

### 10. What's the SQL command INTERSECT do, and when would you use it?

The SQL command INTERSECT merges the results of multiple SELECT statements and keeps only those rows that are present in all sets.

For example, say you were doing an HR Analytics project for Airbnb, and had access to Airbnb's employees and contractors data. Assume that some employees were previously contractors, and vice versa, and thus would show up in both tables. You could use INTERSECT operator to find all contractors who also show up in the employees table:

```sql
SELECT first_name, last_name  
FROM airbnb_contractors

INTERSECT

SELECT first_name, last_name
FROM airbnb_employees
```


---


### 11. Analyze Host Listings and Booking Transactions

As an Airbnb data analyst, you have been asked to analyze the performance of hosts' listings in the past year. Your task is to **identify the top 10 listings with the most bookings.**

There are two tables involved. One is the 'hosts' table that provides details about each host and its respective listing. The other one is 'bookings' table that records each booking transaction.

`hosts` **Example Input:** 

| host_id | listing_id | listing_name | city     |
|---------|------------|--------------|----------|
| 101     | 201        | Penthouse    | New York |
| 102     | 202        | Ocean View   | San Francisco |
| 103     | 203        | Country House| Austin   |



`bookings` **Example Input:** 

| booking_id | user_id | listing_id | booking_date |
|------------|---------|------------|--------------|
| 301        | 401     | 201        | 06/08/2022   |
| 302        | 402     | 202        | 06/10/2022   |
| 303        | 403     | 202        | 07/10/2022   |
| 304        | 404     | 203        | 08/08/2022   | 
| 305        | 405     | 201        | 09/08/2022   |

`Remarks:` Both tables can be joined on the 'listing_id' field.

**Answer:**

```sql
SELECT   listing_id, listing_name, COUNT(booking_id) AS number_of_bookings 
FROM     hosts h LEFT JOIN bookings b USING(listing_id)
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT    10;
```


---