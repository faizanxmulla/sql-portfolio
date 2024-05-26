## 10 Uber SQL Interview Questions

### 1. [Uber Rider's 3rd Trip](https://datalemur.com/questions/uber-sql-3rd-trip)

Assume you are given the table below on Uber transactions made by users. 

**Write a query to obtain the third transaction of every user.** 

Output the user id, spend and transaction date.


`transactions` **Example Input:**

user_id | spend | transaction_date
-- | -- | --
111 | 100.50 | 01/08/2022 12:00:00
111 | 55.00 | 01/10/2022 12:00:00
121 | 36.00 | 01/18/2022 12:00:00
145 | 24.99 | 01/26/2022 12:00:00
111 | 89.60 | 02/05/2022 12:00:00

**Example Output:**

user_id | spend | transaction_date
-- | -- | --
111 | 89.60 | 02/05/2022 12:00:00


**Answer:**

```sql
WITH ranked_transactions as (
    SELECT *, RANK() OVER(PARTITION BY user_id
                          ORDER BY transaction_date)
    FROM   transactions
)
SELECT user_id, spend, transaction_date
FROM   ranked_transactions
WHERE  rank=3
```

---

### 2. Average Duration of Rides Per City  

As a data analyst at Uber, you are tasked with analyzing the ride data to answer the following question - what is the average duration of rides for each city categorized by day of the week?

The duration is categorized into time slots: morning (5:00 to 11:59), afternoon (12:00 to 16:59), evening (17:00 to 20:59), and night (21:00 to 4:59).

`rides` **Example Input:**

ride_id | city_id | start_time | end_time
-- | -- | -- | --
001 | NY | 2022-05-01 07:30:00 | 2022-05-01 07:45:00
002 | SF | 2022-05-01 12:45:00 | 2022-05-01 13:15:00
003 | LA | 2022-05-01 17:00:00 | 2022-05-01 17:25:00
004 | SF | 2022-05-02 09:30:00 | 2022-05-02 09:45:00
005 | LA | 2022-05-02 21:00:00 | 2022-05-02 21:20:00
006 | NY | 2022-05-03 06:30:00 | 2022-05-03 06:50:00
007 | LA | 2022-05-03 14:30:00 | 2022-05-03 14:55:00
008 | SF | 2022-05-03 19:00:00 | 2022-05-03 19:30:00

**Answer:**

```sql
WITH CTE as (
    SELECT   city_id,
             EXTRACT(DOW FROM start_time) as day_of_week,
             ROUND(AVG(EXTRACT(EPOCH FROM (end_time - start_time)) / 60)) as avg_ride_duration_in_minutes,
             EXTRACT(HOUR FROM start_time) as hour
    FROM     rides
    GROUP BY 1, 2, start_time
    ORDER BY 1
)
SELECT   city_id,
	     day_of_week, 
         CASE 
       		  WHEN hour BETWEEN 5 and 11 THEN 'morning'
              WHEN hour BETWEEN 12 and 16 THEN 'afternoon'
              WHEN hour BETWEEN 17 and 20 THEN 'evening'
            ELSE 'night'
         END AS time_of_day,
         avg_ride_duration_in_minutes
FROM     CTE
ORDER BY 1, 2, 4
```

---

### 3. Can you explain the meaning of database denormalization?

Denormalization is a technique used to improve the read performance of a database, typically at the expense of some write performance.  

By adding redundant copies of data or grouping data together in a way that does not follow normalization rules, denormalization improves the performance and scalability of a database by eliminating costly join operations, which is important for OLAP use cases that are read-heavy and have minimal updates/inserts.

---

### 4. Find the Most Used Vehicle Type by Uber's Customers In the Past Year

Uber has a diverse range of vehicles from bikes, scooters, to premium luxury cars. In order to cater their services better, Uber wants to understand their customers' preference. 

**Write a SQL query that filters out the most used vehicle type by Uber's customers in the past year.** 

To provide a more holistic view, the results should also exclude rides that were cancelled by either the driver or the user.

The database contains two tables: `rides` and `vehicle_types`. The `rides` table has a record of all rides taken place and the `vehicle_types` table provides information about the various types of vehicles offered by Uber.

`rides` **Example Input:**

ride_id | user_id | vehicle_type_id | start_time | end_time | cancelled
-- | -- | -- | -- | -- | --
88031 | 61023 | 5 | 2021-07-01 08:15:00 | 2021-07-01 08:45:00 | false
88032 | 61024 | 1 | 2021-07-01 09:15:00 | 2021-07-01 09:45:00 | false
88033 | 61025 | 2 | 2021-07-01 10:15:00 | 2021-07-01 10:45:00 | true
88034 | 61026 | 5 | 2021-07-01 11:15:00 | 2021-07-01 11:45:00 | false
88035 | 61027 | 3 | 2021-07-01 12:15:00 | 2021-07-01 12:45:00 | false

`vehicle_types` **Example Input:**

type_id | vehicle_type
-- | --
1 | Bike
2 | Car
3 | SUV
4 | Luxury Car
5 | Scooter

**Answer:**

```sql
SELECT   vehicle_type, COUNT(ride_id) as ride_count
FROM     vehicle_types v JOIN rides r ON v.type_id=r.vehicle_type_id
WHERE    start_time >= NOW() - INTERVAL '1 YEAR' and cancelled = false 
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1
```

---


### 5. What is normalization?

Normalization involves breaking up your tables into smaller, more specialized ones and using primary and foreign keys to define relationships between them. Not only does this make your database more flexible and scalable, it also makes it easier to maintain. Plus, normalization helps to keep your data accurate by reducing the chance of inconsistencies and errors.

The only downside is now is that your queries will involve more joins, which are slow and often a DB performance bottleneck.

---

### 6. Calculating Conversion Rates for Uber

Assume that you are a data analyst at Uber. The marketing team runs several digital ads attracting users to book a cab. You are required to analyze the click-through conversion rates, i.e., from viewing an ad to booking a cab. 

You have two tables - `ad_clicks` and `cab_bookings`.

`ad_clicks` **Example Input:**

click_id | user_id | ad_id | click_date
-- | -- | -- | --
101 | 7 | 500 | 07/01/2022 00:00:00
102 | 8 | 600 | 07/02/2022 00:00:00
103 | 7 | 500 | 07/03/2022 00:00:00
104 | 8 | 600 | 07/04/2022 00:00:00
105 | 9 | 700 | 07/05/2022 00:00:00

`cab_bookings` **Example Input:**

booking_id | user_id | booking_date
-- | -- | --
201 | 7 | 07/01/2022 00:00:00
202 | 7 | 07/03/2022 00:00:00
203 | 9 | 07/05/2022 00:00:00
204 | 10 | 07/06/2022 00:00:00

The task is to find the click-through conversion rate for each ad, which is the number of bookings made after viewing an ad, divided by the total number of clicks for that ad (i.e., number of bookings / total clicks).

**Answer:**

```sql
SELECT   ad_id, (COUNT(b.user_id)::decimal / COUNT(a.user_id)) AS conversion_rate
FROM     ad_clicks a LEFT JOIN cab_bookings b ON a.user_id = b.user_id AND a.click_date <= b.booking_date
GROUP BY 1
```


---

### 7.  Could you describe a self-join and provide a scenario in which it would be used?

A self-join is a type of join in which a table is joined to itself. To perform a self-join, you need to specify the table name twice in the FROM clause, and give each instance of the table a different alias. You can then join the two instances of the table using a JOIN clause, and use a WHERE clause to specify the relationship between the rows.

Self-joins are the go-to technique for any data analysis that involves pairs of the same thing, like identifying pairs of products that are frequently purchased together like in this [Walmart SQL interview question](https://datalemur.com/questions/sql-frequent-purchases).

For another example, say you were doing an HR analytics project and needed to analyze how much all Uber employees in the same department interact with each other. Here's a self-join query you could use to retrieve all pairs of Uber employees who work in the same department:

```sql
SELECT e1.name AS employee1, e2.name AS employee2  
FROM uber_employees AS e1
JOIN uber_employees AS e2 ON e1.department_id = e2.department_id
WHERE e1.id <> e2.id;
```

This query returns all pairs of Uber employees who work in the same department, and excludes pairs where the employee's id is the same (since this would represent the same Uber employee being paired with themselves).

---

### 8. Average ratings per Driver per City

As a data analyst for Uber, you are asked to determine each driver's average ratings for each city. This will help Uber to monitor performance and perhaps highlight any problems that might be arising in any specific city.  

We have two tables, `rides` and `ratings`.

`rides` **Example Input:**  

ride_id | driver_id | city | fare_amount
-- | -- | -- | --
101 | 201 | New York | 25.50
102 | 202 | San Francisco | 18.00
103 | 203 | Chicago | 22.75
104 | 201 | San Francisco | 30.00
105 | 202 | New York | 20.00

`ratings` **Example Input:**

ride_id | rating  
-- | --
101 | 4.3
102 | 4.1
103 | 4.8
104 | 4.7
105 | 3.9

**Write a SQL query that will create a summary table with each driver's average ratings for each city.**

**Example Output:**

driver_id | city | avg_rating
-- | -- | --
201 | New York | 4.3
202 | San Francisco | 4.1
203 | Chicago | 4.8
201 | San Francisco | 4.7
202 | New York | 3.9

**Answer:**

```sql
SELECT   r.driver_id, r.city, AVG(rt.rating) AS avg_rating
FROM     rides r ratings rt USING(ride_id)
GROUP BY 1, 2
```


---

### 9. Retrieve Users with Gmail IDs

As an SQL analyst at Uber, you are assigned to filter out the customers who have registered using their Gmail IDs. 

You are given a database named 'users'. The records in this table contain multiple email domains. 

**Write an SQL query that filters only those records where the 'email' field contains 'gmail.com'.**

`users` **Example Input:**

user_id | full_name | registration_date | email
-- | -- | -- | --
7162 | John Doe | 05/04/2019 | johndoe@gmail.com
7625 | Jane Smith | 11/09/2020 | janesmith@yahoo.com
5273 | Steve Johnson | 06/20/2018 | stevejohnson@gmail.com
6322 | Emily Davis | 08/14/2021 | emilydavis@hotmail.com
4812 | Olivia Brown | 09/30/2019 | oliviabrown@gmail.com

**Example Output:**

user_id | full_name | registration_date | email 
-- | -- | -- | --
7162 | John Doe | 05/04/2019 | johndoe@gmail.com
5273 | Steve Johnson | 06/20/2018 | stevejohnson@gmail.com
4812 | Olivia Brown | 09/30/2019 | oliviabrown@gmail.com

**Answer:**

```sql
SELECT *
FROM   users
WHERE  email LIKE '%gmail.com';
```
---