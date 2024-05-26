## 10 Lyft SQL Interview Questions

### 1. Identify VIP Lyft Customers

Lyft wants to identify their "VIP" customers which are defined by the number of rides they have taken and the total value of those rides. 

Specifically, such a user has taken at least 50 rides and spent at least $500 in total. The analysis should be based on the last 6 months data.

`rides` **Example Input:**

| ride_id | user_id | date       | price |
|---------|---------|------------|-------|
| 101     | 567     | 06/15/2022 | 20    |
| 102     | 890     | 06/17/2022 | 28    |
| 103     | 890     | 06/25/2022 | 22    |
| 104     | 567     | 07/24/2022 | 14    |
| 105     | 567     | 07/26/2022 | 36    |

`users` **Example Input:**

| user_id | name  |
|---------|-------|
| 567     | Alice |
| 890     | Bob   |

The result should list VIP customer's user_id, name and total spending.

**Answer:**

```sql
SELECT   u.user_id, name, SUM(price) as total_spent
FROM     users u JOIN rides r USING(user_id)
WHERE    date > CURRENT_DATE - INTERVAL '6 months'
GROUP BY 1, 2
HAVING   COUNT(ride_id) >= 50 AND SUM(price) >= 500;
```

---


### 2. Calculate the average Lyft driver rating per month

Lyft has a database table reviews where riders submit a review about a driver after each trip. 

It includes the review_id, rider_id, driver_id, submit_date and stars (rating given by the rider to the driver). The stars column holds integers between 1 and 5. 

**Write a SQL query that returns the average rating trusted drivers receive on a monthly basis.** 

A driver is considered trusted if they have more than 100 reviews in total since they registered.

`reviews` **Example Input:**

| review_id | rider_id | driver_id | submit_date        | stars |
|-----------|----------|-----------|---------------------|-------|
| 890       | 312      | 488       | 06/01/2022 00:00:00 | 5     |
| 891       | 289      | 488       | 06/03/2022 00:00:00 | 4     |
| 892       | 987      | 921       | 06/05/2022 00:00:00 | 3     |
| 893       | 123      | 488       | 06/02/2022 00:00:00 | 4     |
| 894       | 333      | 921       | 06/09/2022 00:00:00 | 5     |
| 895       | 848      | 488       | 07/02/2022 00:00:00 | 2     |
| 896       | 776      | 488       | 07/06/2022 00:00:00 | 5     |
| 897       | 234      | 921       | 07/12/2022 00:00:00 | 2     |
| 898       | 432      | 621       | 07/14/2022 00:00:00 | 4     |
| 899       | 555      | 621       | 07/17/2022 00:00:00 | 4     |

**Answer:**

```sql
WITH CTE AS(
    SELECT   driver_id 
    FROM     reviews
    GROUP BY 1 
    HAVING   COUNT(review_id) > 100
)
SELECT   EXTRACT(MONTH FROM submit_date) as mth,
         driver_id,
         AVG(stars) as avg_stars
FROM     reviews
WHERE    driver_id IN (SELECT driver_id 
                       FROM CTE)
GROUP BY 1, 2
ORDER BY 1, 3 DESC
```

---

### 3. How are LEAD() and LAG() similar, and how are they different?

Both the `LEAD()` and `LAG()` window functions are used to access a row at a specific offset from the current row.

However, the `LEAD()` function retrieves a value from a row that follows the current row, whereas the `LAG()` function retrieves a value from a row that precedes the current row.

Say you had a table of salary data for Lyft employees:

| name    | salary |
|---------|--------|
| Amanda  | 130000 |
| Brandon | 90000  |
| Carlita | 80000  |

You could use the `LEAD()` function to output the salary of each employee, along with the next highest-paid employee:

```sql
SELECT name, salary,
       LEAD(salary, 1) OVER (ORDER BY salary DESC) as next_salary
FROM   lyft_employees;
```

This would yield the following output:

| name    | salary | next_salary |
|---------|--------|-------------|
| Amanda  | 130000 | 90000       |
| Brandon | 90000  | 80000       |
| Carlita | 80000  | NULL        |

Swapping `LEAD(e.salary, 1)` for `LAG(e.salary, 1)` would get you the salary of the person who made just more than you:

| name    | salary | next_salary |
|---------|--------|-------------|
| Amanda  | 130000 | NULL        |
| Brandon | 90000  | 130000      |
| Carlita | 80000  | 90000       |

---

### 4. Analyzing Ride Data for Lyft

As a database engineer at Lyft, your manager approached you to assist in understanding some key metrics about the rides happening through Lyft. 

The company keeps separate tables for drivers, riders, and rides. For rides, they keep track of the ride's ID, the rider's ID, the driver's ID, the start time of the ride, the end time of the ride, the pick-up location, the drop-off location, and the cost of the ride.

**Your task is to design a query that will yield, for each driver, the total number of rides they've given and the average ride cost.**

Also, we need to know how many of these rides were over $20 for each particular driver.

`drivers` **Example Input:**

| driver_id | name   |
|-----------|--------|
| 1         | Justin |
| 2         | Amanda |
| 3         | Ben    |


`rides` **Example Input:**

| ride_id | rider_id | driver_id | start_time          | end_time            | pick_up    | drop_off   | cost |
|---------|----------|-----------|----------------------|----------------------|------------|------------|------|
| 2001    | 1001     | 1         | 06/08/2021 09:20:00 | 05/08/2021 09:50:00 | "Location-A" | "Location-B" | 25.0 |
| 2002    | 1002     | 2         | 06/08/2021 10:00:00 | 05/08/2021 11:00:00 | "Location-B" | "Location-C" | 15.0 |
| 2003    | 1002     | 1         | 06/08/2021 12:00:00 | 05/08/2021 12:30:00 | "Location-C" | "Location-A" | 22.0 |
| 2004    | 1003     | 1         | 06/08/2021 13:00:00 | 05/08/2021 13:30:00 | "Location-C" | "Location-D" | 30.0 |
| 2005    | 1004     | 3         | 06/08/2021 14:00:00 | 05/08/2021 14:30:00 | "Location-D" | "Location-A" | 18.0 |

**Answer:**

```sql
SELECT   d.driver_id,
         name,
         COUNT(ride_id) AS total_rides,
         AVG(cost) AS avg_cost,
         SUM(CASE WHEN cost > 20 THEN 1 ELSE 0 END) AS rides_over_20
FROM     drivers d JOIN rides r USING(driver_id)
GROUP BY 1
```

---

### 5. What do stored procedures do, and when would you use one?

Stored procedures are like functions in Python – they can accept input params and return values, and are used to encapsulate complex logic.

For example, if you worked as a Data Analyst in support of the Marketing Analytics team at Lyft, a common task might be to find the conversion rate for your ads given a specific time-frame. Instead of having to write this query over-and-over again, you could write a stored procedure like the following:

```sql
CREATE FUNCTION get_conversion_rate(start_date DATE, end_date DATE, event_name TEXT)
RETURNS NUMERIC AS
$BODY$
BEGIN
  RETURN (SELECT COUNT(*) FROM events WHERE event_date BETWEEN start_date AND end_date AND event_name = 'conversion')
          / (SELECT COUNT(*) FROM events WHERE event_date BETWEEN start_date AND end_date AND event_name = 'impression');
END;
$BODY$
LANGUAGE 'plpgsql';
```

To call this stored procedure, you'd execute the following query:

```sql
SELECT get_conversion_rate('2023-01-01', '2023-01-31', 'conversion');
```

---

### 6. Finding the average trip cost per city

Lyft wants to keep a close eye on the average cost of their trips for each city where they operate. 

They have a table that keeps track of all individual rides, recording the cost for each ride along with the city where the ride occurred. 

**Write a query to find the average cost of trips in each city.**

`rides` **Example Input:**

| ride_id | city   | trip_cost |
|---------|--------|-----------|
| 001     | Rome   | 14        |
| 002     | Paris  | 18        |
| 003     | Rome   | 20        |
| 004     | Berlin | 24        |
| 005     | Rome   | 12        |
| 006     | Paris  | 22        |
| 007     | Berlin | 30        |
| 008     | Berlin | 28        |

**Answer:**

```sql
SELECT   city, AVG(trip_cost) as avg_cost
FROM     rides
GROUP BY 1
```

---

### 7. What distinguishes a left join from a right join?

Both left and right joins in SQL allow you to combine data from different tables based on a shared key or set of keys. For a concrete example of the difference between these two join types, say you had sales data exported from Lyft's Salesforce CRM stored in a PostgreSQL database, and had access to two tables: `sales` and `lyft_customers`.

**LEFT JOIN:** retrieves all rows from the left table (in this case, the `sales` table) and any matching rows from the right table (the `lyft_customers` table). If there is no match in the right table, NULL values will be returned for the right table's columns.

**RIGHT JOIN:** retrieves all rows from the right table (in this case, the `customers` table) and any matching rows from the left table (the `sales` table). If there is no match in the left table, NULL values will be returned for the left table's columns.

---

### 8. Lyft Rider Pattern Matching

Lyft maintains a database of its users and their associated rides. As a data analyst at Lyft, you are asked to find all the users whose first name starts with 'J' and who have taken a ride in 'San Francisco'. 

**Write a SQL query to filter these user records from the database.**

`users` **Example Input:**

| user_id | first_name | last_name | email                |
|---------|------------|-----------|----------------------|
| 123     | John       | Doe       | john.doe@lyft.com    |
| 265     | Jane       | Smith     | jane.smith@lyft.com  |
| 362     | Jack       | Taylor    | jack.taylor@lyft.com |
| 192     | Jennifer   | Johnson   | jennifer.johnson@lyft.com |
| 981     | Alice      | Kim       | alice.kim@lyft.com   |

`rides` **Example Input:**

| ride_id | user_id | city          | ride_date           |
|---------|---------|----------------|----------------------|
| 101     | 123     | San Francisco | 06/08/2022 00:00:00 |
| 102     | 265     | San Francisco | 06/10/2022 00:00:00 |
| 103     | 362     | New York      | 06/18/2022 00:00:00 |
| 104     | 192     | San Francisco | 07/26/2022 00:00:00 |
| 105     | 981     | Los Angeles   | 07/05/2022 00:00:00 |

**Answer:**

```sql
SELECT u.*
FROM   users u JOIN rides r USING(user_id)
WHERE  first_name LIKE 'J%' AND city = 'San Francisco';
```

---


### 9. Calculate Driver Performance Statistics

Lyft wants to evaluate its drivers' performance based on the trip completion duration and the tips received per trip. 

Suppose you are a data scientist and you are tasked with calculating : 

- the average absolute tip amount, 

- the square root of the total trips completed by each driver, 

- the rounded ratio of tip received and the trip duration, and 

- the total amount of `power(2, tips)` the driver received. 

Here is the trips data:

`driver_trips` **Example Input:**

| trip_id | driver_id | trip_duration_minutes | tip_amount |
|---------|-----------|------------------------|------------|
| 1001    | 1         | 30                     | 5          |
| 1002    | 1         | 45                     | 10         |
| 1003    | 2         | 60                     | 7          |
| 1004    | 2         | 20                     | 4          |
| 1005    | 3         | 50                     | 9          |

**Example Output:**

| driver_id | avg_abs_tip | sqrt_total_trips | rounded_tip_duration_ratio | pow_of_tips |
|-----------|-------------|-------------------|---------------------------|-------------|
| 1         | 7.5 | 1.4 | 0.27 | 525 |
| 2 | 5.5 | 1.4 | 0.18 | 121 |
| 3 | 9.0 | 1.0 | 0.18 | 81 |

**Answer:**

```sql
SELECT   driver_id, 
         AVG(ABS(tip_amount)) AS avg_abs_tip,
         SQRT(COUNT(trip_id)) AS sqrt_total_trips,
         ROUND(AVG(tip_amount::decimal / trip_duration_minutes::decimal), 2) AS rounded_tip_duration_ratio,
         SUM(POWER(2, tip_amount)) AS pow_of_tips
FROM     driver_trips 
GROUP BY 1
```

---

### 10. Can you explain what MINUS / EXCEPT SQL commands do?

Note: interviews at Lyft often aren't trying to test you on a specific flavor of SQL. As such, you don't need to exactly know that EXCEPT is available in PostgreSQL and SQL Server, while MINUS is available in MySQL and Oracle – you just need to know the general concept!

Your answer should mention that the `MINUS/EXCEPT` operator is used to remove to return all rows from the first `SELECT` statement that are not returned by the second `SELECT` statement.

Here's a PostgreSQL example of using `EXCEPT` to find all of Lyft's Facebook video ads with more than 50k views that aren't also being run on YouTube:

```sql
SELECT ad_creative_id
FROM   lyft_facebook_ads
WHERE  views > 50000 AND type=video

EXCEPT

SELECT ad_creative_id
FROM   lyft_youtube_ads
```

If you want to retain duplicates, you can use the `EXCEPT ALL` operator instead of `EXCEPT`. The `EXCEPT ALL` operator will return all rows, including duplicates.

---