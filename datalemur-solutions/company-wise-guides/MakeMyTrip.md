## 8 MakeMyTrip SQL Interview Questions

### 1. Find The Most Popular Destinations And Their Average Ratings Over Time

Given the `destinations` and `reviews` tables below, **write an SQL query to find out the top 3 most popular destinations for each month (based on the number of reviews), and their average ratings**.

A destination is considered popular if it receives many reviews.

`destinations` **Example Input:**

| **destination_id** | **destination_name** |
|:-------------------|:---------------------|
| 50001              | "Delhi"              |
| 69852              | "Mumbai"             |
| 12345              | "Bangalore"          |
| 56891              | "Chennai"            |
| 12378              | "Kolkata"            |

`reviews` **Example Input:**

| **review_id** | **user_id** | **submit_date**     | **destination_id** | **stars** |
|:--------------|:------------|:---------------------|:-------------------|:----------|
| 6342          | 123         | 06/05/2022 00:00:00 | 50001              | 4         |
| 3502          | 482         | 06/10/2022 00:00:00 | 69852              | 5         |
| 7162          | 965         | 06/15/2022 00:00:00 | 50001              | 4         |
| 5279          | 256         | 07/01/2022 00:00:00 | 12345              | 3         |
| 4912          | 213         | 07/08/2022 00:00:00 | 12345              | 2         |
| 1154          | 756         | 07/12/2022 00:00:00 | 12345              | 3         |

**Answer:**

```sql
WITH monthly_reviews AS (
    SELECT   EXTRACT(MONTH FROM submit_date) AS month,
             destination_id,
             COUNT(review_id) AS number_of_reviews,
             AVG(stars) AS avg_rating
    FROM     reviews
    GROUP BY 1, 2
),
ranked_destinations AS (
    SELECT month,
           destination_id,
           number_of_reviews,
           avg_rating,
           RANK() OVER (PARTITION BY month ORDER BY number_of_reviews DESC)
    FROM   monthly_reviews
)
SELECT month, destination_name, number_of_reviews, avg_rating
FROM   ranked_destinations rd JOIN destinations d USING(destination_id)
WHERE  rank <= 3;
```

---

### 2. Analyzing Hotel Booking Data

As a data engineer at MakeMyTrip, your task is to design a database to help management understand the booking pattern of their customers. The company needs a way to **know the most preferred room type and the most frequently visited cities by the customers.**

Design a database for `'trips'` and `'hotel_rooms'`. 

- `'trips'` tables will have columns such as 'trip_id', 'user_id', 'city_id', 'hotel_id', 'room_id', 'check_in_date' and 'check_out_date'. 

- `'hotel_rooms'` tables will have columns like 'room_id', 'hotel_id', 'room_type' and 'price_per_night'.

Each row in the 'trips' table represents a trip made by a user, and each row in the 'hotel_rooms' table represents a type of room in a hotel.

`trips` **Example Input:**

| trip_id | user_id | city_id | hotel_id | room_id | check_in_date | check_out_date |
|:--------|:--------|:--------|:---------|:--------|:---------------|:----------------|
| 101     | 1056    | 3       | 152      | 246     | 01/02/2023     | 01/10/2023      |
| 102     | 2031    | 1       | 109      | 235     | 01/05/2023     | 01/10/2023      |
| 103     | 3210    | 3       | 152      | 354     | 01/06/2023     | 01/20/2023      |
| 104     | 1056    | 2       | 207      | 246     | 01/11/2023     | 01/15/2023      |

`hotel_rooms` **Example Input:**

| room_id | hotel_id | room_type | price_per_night |
|:--------|:---------|:-----------|:----------------|
| 234     | 152      | 'premium' | 160             |
| 235     | 109      | 'economy' | 100             |
| 246     | 207      | 'deluxe'  | 200             |
| 354     | 152      | 'premium' | 160             |


**Write a SQL query to find out what was the most preferred room type among customers who visited city with id=3 in January 2023.**

**Answer:**

```sql
SELECT   room_type, COUNT(*) AS number_of_bookings
FROM     trips t JOIN hotel_rooms hr USING(room_id)
WHERE    t.city_id = 3 AND t.check_in_date >= '2023-01-01' AND t.check_out_date < '2023-02-01' 
GROUP BY 1
ORDER BY 2 DESC 
LIMIT    1;
```

---

### 3. Could you explain what a self-join is?

A self-join is a type of join in which a table is joined to itself. To perform a self-join, you need to specify the table name twice in the FROM clause, and give each instance of the table a different alias. You can then join the two instances of the table using a JOIN clause, and use a WHERE clause to specify the relationship between the rows.

Self-joins are the go-to technique for any data analysis that involves pairs of the same thing, like identifying pairs of products that are frequently purchased together like in this Walmart SQL interview question.

For another example, say you were doing an HR analytics project and needed to analyze how much all MakeMyTrip employees in the same department interact with each other. Here's a self-join query you could use to retrieve all pairs of MakeMyTrip employees who work in the same department:

```sql
SELECT e1.name AS employee1, e2.name AS employee2
FROM   makemytrip_employees AS e1
JOIN   makemytrip_employees AS e2 ON e1.department_id = e2.department_id
WHERE  e1.id <> e2.id;
```

This query returns all pairs of MakeMyTrip employees who work in the same department, and excludes pairs where the employee's id is the same (since this would represent the same MakeMyTrip employee being paired with themselves).

---

### 4. Filter Customers Based on Booking and Cancellation Information

MakeMyTrip wants to target customers who booked for a trip but cancelled it later within a specified range of time. They have two tables: `bookings` and `cancellations`.

Your task is to **write a SQL query to find all the customers who booked a trip for the month of August 2022, but cancelled it within a week.** 

The result should show the customer_id, their booking_date, their cancellation_date and the number of days between the booking and cancellation.


`bookings` **Example Input:**

| booking_id | customer_id | booking_date |
|------------|-------------|--------------|
| 101        | 120         | 8/1/2022     |
| 102        | 121         | 8/5/2022     | 
| 103        | 122         | 8/20/2022    |
| 104        | 120         | 8/25/2022    |


`cancellations` **Example Input:** 

| cancellation_id | booking_id | cancellation_date |
|-----------------|-------------|-------------------|
| 501             | 101        | 8/2/2022          |
| 502             | 102        | 8/13/2022         |
| 503             | 103        | 8/24/2022         |
| 504             | 104        | 8/26/2022         |

**Answer:**

```sql
SELECT customer_id, booking_date, cancellation_date, 
       EXTRACT(DAY FROM AGE(cancellation_date, booking_date)) AS diff
FROM   bookings b JOIN cancellations c USING(booking_id)
WHERE  booking_date BETWEEN '2022-08-01' AND '2022-08-31' AND 
       EXTRACT(DAY FROM AGE(cancellation_date, booking_date)) <= 7;
```

---

### 5. What would you do to optimize a SQL query that was running slow?

First things first, figure out why the query is slow! You can use `ANALYZE` and `EXPLAIN` commands in PostgreSQL to identify any performance bottlenecks. You might discover that your query is inefficient, or that there are many database writes at the same time you are doing a read, or maybe too many people are concurrently running queries on the same database server.

For Data Analyst and Data Science positions, knowing the ins-and-outs of SQL performance tuning is out-of-scope for the SQL interview round. However, knowing that joins are expensive, and indexes can speed up queries, is generally enough of an answer for MakeMyTrip SQL interviews.

---

### 6. Find the average ticket price for each airline

At MakeMyTrip, we work with a variety of airlines and we consistently maintain a range of ticket prices. 

The task is to **find the average ticket price for each airline over the past year**.

`flights` **Example Input:**

| flight_id | airline   | ticket_price | flight_date |
|-----------|-----------|--------------|-------------|
| 1001      | Air India | 10000        | 01/08/2021  |
| 1002      | Jet Airways| 12000        | 05/10/2021  |
| 1003      | Air India | 15000        | 06/09/2021  |
| 1004      | SpiceJet  | 8000         | 07/26/2021  |
| 1005      | Indigo    | 6000         | 07/05/2021  |


**Example Output:**

| airline   | avg_ticket_price |
|-----------|-------------------|
| Air India | 12500             |
| Jet Airways| 12000             |
| SpiceJet  | 8000              |
| Indigo    | 6000              |

**Answer:**

```sql
SELECT   airline, AVG(ticket_price) AS avg_ticket_price
FROM     flights
WHERE    flight_date BETWEEN '01/01/2021' AND '12/31/2021'
GROUP BY 1
```

---

### 7. What are the similarities and differences between correleated and non-correlated sub-queries?

A non-correlated sub-query is not linked to the outer query and can be run on its own. It does not reference any columns from the outer query and is used to retrieve additional data for the outer query. On the other hand, a correlated sub-query is one that relies on the outer query and cannot be run independently. It uses the outer query to filter or transform data by referencing a column from it, while the outer query uses the results of the inner query.

Here is an example of a non-correlated sub-query:

```sql
SELECT t1.customer_id, t1.total_sales
FROM   makemytrip_sales t1
WHERE  t1.total_sales > (
  SELECT AVG(t2.total_sales)
  FROM   makemytrip_sales t2
);
```

The sub-query in this case is non-correlated, as it does not reference any columns from the outer query.

Here is an example of a correlated sub-query:

```sql 
SELECT t1.customer_id, t1.total_sales
FROM   makemytrip_sales t1
WHERE  t1.total_sales > (
  SELECT AVG(t2.total_sales)
  FROM   makemytrip_sales t2
  WHERE  t2.customer_id = t1.customer_id
);
```

This query selects the `customer_id` and `total_sales` of all MakeMyTrip customers in the `sales` table whose `total_sales` are greater than the average `total_sales` of their own customer group. The sub-query in this case is correlated with the outer query, as it references the `customer_id` column from the outer query (`t1.customer_id`).

Non-correlated sub-queries are typically faster, as they only have to be executed once, whereas correlated sub-queries are slower since they have to be re-evaluated for each row of the outer query.

---


### 8. Average Price Paid per Hotel by each City

Given the below `bookings` and `hotels` tables, **write a SQL query that returns the average amount paid (rounded to the nearest integer) per hotel in each city**.

`bookings` **Example Input:**

| booking_id | user_id | hotel_id | checkin_date        | checkout_date       | amount_paid |
|------------|---------|----------|----------------------|----------------------|-------------|
| 3972       | 543     | 1001     | 06/08/2022 00:00:00 | 06/10/2022 00:00:00 | 10000       |
| 2351       | 348     | 1002     | 06/10/2022 00:00:00 | 06/12/2022 00:00:00 | 8000        |
| 8921       | 645     | 2001     | 06/18/2022 00:00:00 | 06/20/2022 00:00:00 | 12000       |
| 3589       | 234     | 1001     | 07/26/2022 00:00:00 | 07/28/2022 00:00:00 | 9800        |
| 6471       | 789     | 2002     | 07/05/2022 00:00:00 | 07/07/2022 00:00:00 | 7500        |

`hotels` **Example Input:**

| hotel_id | city  |
|----------|-------|
| 1001     | Delhi |
| 1002     | Delhi |
| 2001     | Mumbai|
| 2002     | Mumbai|

**Answer:**

```sql
SELECT   city, 
         b.hotel_id, 
         ROUND(AVG(amount_paid)) as avg_amount_paid
FROM     bookings b JOIN hotels h USING(hotel_id)
GROUP BY 1, 2
ORDER BY 1, 3 DESC
```

---