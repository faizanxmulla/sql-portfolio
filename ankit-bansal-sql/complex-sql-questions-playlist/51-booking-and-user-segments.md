### Problem Statement

Given two tables: `bookings` and `users`, perform the following queries:

1. Write an SQL query to give the following output, which provides a summary at the segment level:

2. Write a query to identify users whose first booking was a hotel booking.

3. Write a query to calculate the days between the first and last booking of each user.

4. Write a query to count the number of flight and hotel bookings for each user segment.


### Schema Setup

```sql
CREATE TABLE bookings (
    booking_id VARCHAR(10),
    booking_date DATE,
    user_id VARCHAR(10),
    line_of_business VARCHAR(10)
);

CREATE TABLE users (
    user_id VARCHAR(10),
    segment VARCHAR(10)
);

INSERT INTO bookings VALUES
('b1', '2022-03-23', 'u1', 'Flight'),
('b2', '2022-03-27', 'u2', 'Flight'),
('b3', '2022-03-28', 'u1', 'Hotel'),
('b4', '2022-03-31', 'u4', 'Flight'),
('b5', '2022-04-02', 'u1', 'Hotel'),
('b6', '2022-04-04', 'u2', 'Flight'),
('b7', '2022-04-06', 'u5', 'Flight'),
('b8', '2022-04-06', 'u6', 'Hotel'),
('b9', '2022-04-06', 'u2', 'Flight'),
('b10', '2022-04-09', 'u1', 'Flight'),
('b11', '2022-04-12', 'u4', 'Flight'),
('b12', '2022-04-12', 'u1', 'Flight'),
('b13', '2022-04-19', 'u2', 'Flight'),
('b14', '2022-04-24', 'u5', 'Hotel'),
('b15', '2022-04-26', 'u6', 'Flight'),
('b16', '2022-04-28', 'u4', 'Hotel'),
('b17', '2022-05-02', 'u2', 'Hotel'),
('b18', '2022-05-04', 'u1', 'Hotel'),
('b19', '2022-05-06', 'u4', 'Hotel'),
('b20', '2022-05-06', 'u1', 'Flight');

INSERT INTO users VALUES
('u1', 's1'),
('u2', 's1'),
('u3', 's1'),
('u4', 's2'),
('u5', 's2'),
('u6', 's3'),
('u7', 's3'),
('u8', 's3'),
('u9', 's3'),
('u10', 's3');
```

### Expected Output

- **Query 1 Output**:

    | segment | total_user_count | users_who_booked_flight_in_apr2022 |
    |---------|------------------|-----------------------------------|
    | s1      | 3                | 2                                 |
    | s2      | 2                | 2                                 |
    | s3      | 5                | 1                                 |


- **Query 2 Output**:

    user_id |
    --|
    6 |



- **Query 3 Output**:

    user_id |	days_between_first_and_last_booking |
    --|--|
    u1 |	44 |
    u2 |	36 |
    u4 |	36 |
    u5 |	18 |
    u6 |	20 |



- **Query 4 Output**:


    segment |	no_of_flights_booking |	no_of_hotel_booking |
    --|--|--|
    s1 |	8 |	4 |
    s2 |	3 |	3 |
    s3 |	1 |	1 |



### Solution Query

```sql
-- Query 1

SELECT   segment, 
         COUNT(DISTINCT user_id) as total_user_count,
         COUNT(DISTINCT user_id) FILTER(WHERE TO_CHAR(booking_date, 'YYYY-MM')='2022-04') as users_who_booked_flight_in_apr2022
FROM     users u LEFT JOIN bookings b USING(user_id)
GROUP BY 1
ORDER BY 1
```

```sql
-- Query 2

SELECT user_id
FROM   bookings
WHERE  booking_date IN (
          SELECT MIN(booking_date)
          FROM   bookings
          GROUP BY user_id
        )
and line_of_business = 'Hotel'
```


```sql
-- Query 3 (works in MySQL)

SELECT   user_id, 
         DATEDIFF(MAX(booking_date), MIN(booking_date)) AS     days_between_first_and_last_booking
FROM     bookings
GROUP BY 1


-- my attempt (doesnt work; but correct idea / approach)

SELECT   user_id, 
         EXTRACT(EPOCH FROM (MIN(booking_date) - MAX(booking_date))::int / 86400) AS days_between_first_and_last_booking
FROM     bookings
GROUP BY 1
```


```sql
-- Query 4

SELECT   segment,
         SUM(CASE WHEN b.line_of_business = 'Flight' THEN 1 ELSE 0 END) AS no_of_flights_booking,
         SUM(CASE WHEN b.line_of_business = 'Hotel' THEN 1 ELSE 0 END) AS no_of_hotel_booking
FROM     users u LEFT JOIN bookings b USING(user_id)
WHERE    EXTRACT(YEAR FROM booking_date)='2022'
GROUP BY 1
ORDER BY 1
```

