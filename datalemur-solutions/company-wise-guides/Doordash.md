## 8 DoorDash SQL Interview Questions

### 1. First 14-Day Satisfaction

The Growth Team at DoorDash wants to ensure that new users, who make orders within their first 14 days on the platform, have a positive experience. However, they have noticed several issues with deliveries that result in a bad experience.

These issues include:

- Orders being completed incorrectly, with missing items or wrong orders.

- Orders not being received due to incorrect addresses or drop-off spots.
- Orders being delivered late, with the actual delivery time being 30 minutes later than the order placement time. Note that the estimated_delivery_timestamp is automatically set to 30 minutes after the order_timestamp.

**Write a query that calculates the bad experience rate for new users who signed up in June 2022 during their first 14 days on the platform.**

The output should include the percentage of bad experiences, rounded to 2 decimal places.


`orders` **Example Input:**

order_id | customer_id | trip_id | status | order_timestamp
-- | -- | -- | -- | --
727424 | 8472 | 100463 | completed successfully | 06/05/2022 09:12:00
242513 | 2341 | 100482 | completed incorrectly | 06/05/2022 14:40:00  
141367 | 1314 | 100362 | completed incorrectly | 06/07/2022 15:03:00
582193 | 5421 | 100657 | never_received | 07/07/2022 15:22:00
253613 | 1314 | 100213 | completed successfully | 06/12/2022 13:43:00


`trips` **Example Input:**

dasher_id | trip_id | estimated_delivery_timestamp | actual_delivery_timestamp
-- | -- | -- | --
101 | 100463 | 06/05/2022 09:42:00 | 06/05/2022 09:38:00
102 | 100482 | 06/05/2022 15:10:00 | 06/05/2022 15:46:00
101 | 100362 | 06/07/2022 15:33:00 | 06/07/2022 16:45:00
102 | 100657 | 07/07/2022 15:52:00 | -
103 | 100213 | 06/12/2022 14:13:00 | 06/12/2022 14:10:00


`customers` **Example Input:**

customer_id | signup_timestamp
-- | --
8472 | 05/30/2022 00:00:00
2341 | 06/01/2022 00:00:00
1314 | 06/03/2022 00:00:00
1435 | 06/05/2022 00:00:00
5421 | 06/07/2022 00:00:00

**Example Output:**

bad_experience_pct |
-- |
75.00 |


**Answer:**

```sql
WITH june_2022_cte AS (
    SELECT customer_id, signup_timestamp
    FROM   customers
    WHERE  EXTRACT(MONTH FROM signup_timestamp) = 6 AND EXTRACT(YEAR FROM signup_timestamp) = 2022
),
bad_orders_cte AS (
    SELECT o.*
    FROM   june_2022_cte j JOIN orders o USING(customer_id)
    WHERE  status NOT IN ('completed successfully')
),
late_deliveries_cte AS (
    SELECT t.*
    FROM   bad_orders_cte o JOIN trips t USING(trip_id)
    WHERE  t.estimated_delivery_timestamp - t.actual_delivery_timestamp > INTERVAL '30 minutes'
)
SELECT ROUND(100.0 * COUNT(o.order_id) / 
                     NULLIF((
                            SELECT COUNT(*) 
                            FROM   bad_orders_cte), 0)
            , 2) AS bad_experience_pct
FROM   bad_orders_cte o JOIN june_2022_cte j USING(customer_id)
WHERE  o.order_timestamp <= j.signup_timestamp + INTERVAL '14 days'
AND NOT EXISTS (
    SELECT 1
    FROM   late_deliveries_cte l
    WHERE  l.trip_id = o.trip_id
);
```

---

### 2. Analyze DoorDash Delivery Performance

As a Data Analyst at DoorDash, you're tasked to analyze the delivery performance of the drivers. 

Specifically, you are asked to compute the average delivery duration of each driver for each day, the rank of each driver's daily average delivery duration, and the overall average delivery duration per driver.

Use the `deliveries` table where each row represents a single delivery. The columns are:

- `delivery_id`: An identifier for the delivery

- `driver_id`: An identifier for the driver  
- `delivery_start_time`: Timestamp for the start of the delivery
- `delivery_end_time`: Timestamp for the end of the delivery

`deliveries` **Example Input:**

delivery_id | driver_id | delivery_start_time | delivery_end_time
-- | -- | -- | --
1 | 123 | 08/01/2022 14:00:00 | 08/01/2022 14:40:00
2 | 123 | 08/01/2022 15:15:00 | 08/01/2022 16:10:00
3 | 265 | 08/01/2022 14:00:00 | 08/01/2022 15:30:00
4 | 265 | 08/01/2022 16:00:00 | 08/01/2022 16:50:00
5 | 123 | 08/02/2022 11:00:00 | 08/02/2022 11:35:00

The output should have the following fields:

- `driver_id`

- `day`
- `avg_delivery_duration`: Average minutes taken to for a delivery in a particular day
- `rank`: Rank over the daily average duration for each driver
- `overall_avg_delivery_duration`: Average minutes taken to deliver for all deliveries the driver has made

**Answer:**

```sql
WITH delivery_cte as (
    SELECT   driver_id, 
             EXTRACT(DAY FROM delivery_start_time) as day, 
             ROUND(AVG(EXTRACT(EPOCH FROM (delivery_end_time - delivery_start_time) / 60)), 2) AS avg_delivery_duration
    FROM     deliveries
    GROUP BY 1, 2
    ORDER BY 1, 2
)
SELECT *, 
	   RANK() OVER(PARTITION BY driver_id ORDER BY avg_delivery_duration),
       ROUND(AVG(avg_delivery_duration) OVER(PARTITION BY driver_id), 2) as overall_avg_delivery_duration
FROM   delivery_cte
```

---



### 3. Can you explain what an index is and the various types of indexes?

A database index is a way to optimize the performance of a database by reducing the amount of data that needs to be searched to retrieve a record.  

There are several types of indexes:

- unique & non-unique indexes

- primary & composite indexes
- clustered & non-clustered indexes

---

### 4. Restaurant Performance Analysis

As a DoorDash data analyst, your task is to understand the behavior and preferences of DoorDash users, which would be fundamental in improving the service. 

One of the essential measures of service quality and restaurant popularity is the number of orders each restaurant receives over time. Your task is to design a database consisting of restaurants, users, and orders.

Given the `restaurants`, `users`, and `orders` tables below, please write a query to identify the top 5 restaurants with the most orders in the last month.

`restaurants` **Example Input**

restaurant_id | restaurant_name
-- | --
001 | Burger King
002 | KFC  
003 | McDonald's
004 | Pizza Hut
005 | Starbucks

`users` **Example Input**

user_id | user_name
-- | --
101 | John Doe
102 | Jane Smith
103 | Bob Johnson 
104 | Alice Anderson
105 | Emma Wilson

`orders` **Example Input**

order_id | user_id | restaurant_id | order_date
-- | -- | -- | --
2001 | 101 | 001 | 2022-10-01
2002 | 102 | 002 | 2022-10-02
2003 | 101 | 003 | 2022-10-03
2004 | 103 | 002 | 2022-10-04 
2005 | 102 | 001 | 2022-10-05
2006 | 104 | 004 | 2022-10-06
2007 | 105 | 005 | 2022-10-07
2008 | 101 | 001 | 2022-10-08
2009 | 102 | 002 | 2022-10-09
2010 | 104 | 005 | 2022-10-10

**Answer:**

```sql
SELECT   r.restaurant_name, COUNT(o.order_id) as order_count
FROM     orders o JOIN restaurants r USING(restaurant_id)
WHERE    o.order_date >= NOW() - INTERVAL '1 month'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    5;
```



---

### 5. Can you give an example of a one-to-one relationship between two entities, vs. a one-to-many relationship?

In database schema design, a one-to-one relationship between two entities is where each entity is associated with only one instance of the other entity. For example, the relationship between a car and a license plate is one-to-one, because each car can only have one license plate, and each license plate belongs to exactly one car.

On the other hand, a one-to-many relationship is where one entity can be associated with multiple instances of the 2nd entity. For example, a teacher can teach multiple classes, but each class is associated with only one teacher.

---

### 6. Average Delivery Time per Restaurant 

As an analyst at DoorDash, you are asked to measure the performance of restaurant partners. One important measure is the average delivery time associated with each restaurant. 

Assume that we calculate the delivery time by the difference between the order time and delivery completion time. 

**Write a SQL query to find the average delivery time for each restaurant.**

Please consider the following tables:

`orders` **Example Input:**

order_id | order_time | delivery_time | restaurant_id | customer_id
-- | -- | -- | -- | --
0001 | 08/25/2021 18:00:00 | 08/25/2021 18:40:00 | 100 | 123
0002 | 08/25/2021 19:00:00 | 08/25/2021 19:30:00 | 200 | 265
0003 | 08/25/2021 20:00:00 | 08/25/2021 20:40:00 | 200 | 362
0004 | 08/25/2021 21:00:00 | 08/25/2021 21:35:00 | 300 | 192
0005 | 08/25/2021 22:00:00 | 08/25/2021 22:45:00 | 100 | 981

**Example Output:**

restaurant_id | avg_delivery_time_in_minutes 
-- | --
100 | 42.5
200 | 35.0
300 | 35.0

**Answer:**

```sql
SELECT   restaurant_id,
         ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - order_time)) / 60), 2) AS avg_delivery_time_in_minutes
FROM     orders
GROUP BY 1
```

---

### 7. How does the LEAD() function differ from the LAG() function?

Both window functions are used to find rows at a given offset from the current row. However, `LEAD()` will give you the rows AFTER the current row you. On the other hand, `LAG()` will give you the rows BEFORE the current row.

---

### 8.  Calculating Courier Average Distance and Total Revenue

You are the data analyst at DoorDash and it's your job to **calculate the average distance travelled**, rounded to the nearest whole number, and the **total revenue for each courier id in the last month**. The total revenue for each courier is calculated by summing all the delivery fee times the quantity of deliveries. 

The courier fee is the absolute difference between the delivery's start point and end point, expressed as an integer with two decimal places. If the courier fee is greater than the delivery fee, the courier fee becomes the new delivery fee.

Consider the following table `deliveries`

`deliveries` **Example Input:**

delivery_id | courier_id | start_point | end_point | delivery_fee | quantity | date
-- | -- | -- | -- | -- | -- | --
1001 | 501 | 10 | 15 | 5.00 | 3 | 01/01/2022
1002 | 501 | 5 | 7 | 2.00 | 2 | 02/01/2022  
1003 | 501 | 0 | 3 | 3.00 | 1 | 03/01/2022
1004 | 502 | 18 | 20 | 2.00 | 4 | 03/01/2022
1005 | 503 | 30 | 35 | 5.00 | 1 | 03/01/2022

**Answer:**

```sql
SELECT   courier_id,
         ROUND(AVG(ABS(start_point - end_point))) AS avg_distance,
         SUM( 
            CASE 
                WHEN ABS(start_point - end_point) > delivery_fee THEN ABS(start_point - end_point) * quantity
                ELSE delivery_fee * quantity 
            END) AS total_revenue
FROM     deliveries
WHERE    date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 1
```

---