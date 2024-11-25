### Problem Statement

You are given a day worth of scheduled departure and arrival times of trains at one train station. 

One platform can only accommodate one train from the beginning of the minute it's scheduled to arrive until the end of the minute it's scheduled to depart. 

Find the minimum number of platforms necessary to accommodate the entire scheduled traffic.

**Company**: GoldmanSachs, Deloitte 

**Problem Source**: [Nishant Kumar - Linkedin Post 18.11.2024](https://www.linkedin.com/posts/im-nsk_sql-activity-7264110070248947713-t3Vn?utm_source=share&utm_medium=member_desktop)


### Schema Setup

```sql
CREATE TABLE train_arrivals (train_id INT, arrival_time TIMESTAMP);
CREATE TABLE train_departures (train_id INT, departure_time TIMESTAMP);


INSERT INTO train_arrivals (train_id, arrival_time) VALUES
(1, '2024-11-17 08:00'),(2, '2024-11-17 08:05'),(3, '2024-11-17 08:05'),
(4, '2024-11-17 08:10'),(5, '2024-11-17 08:10'),(6, '2024-11-17 12:15'),
(7, '2024-11-17 12:20'),(8, '2024-11-17 12:25'),(9, '2024-11-17 15:00'),
(10, '2024-11-17 15:00'),(11, '2024-11-17 15:00'),(12, '2024-11-17 15:06'),
(13, '2024-11-17 20:00'),(14, '2024-11-17 20:10');

INSERT INTO train_departures (train_id, departure_time) VALUES
(1, '2024-11-17 08:15'),(2, '2024-11-17 08:10'),(3, '2024-11-17 08:20'),
(4, '2024-11-17 08:25'),(5, '2024-11-17 08:20'),(6, '2024-11-17 13:00'),
(7, '2024-11-17 12:25'),(8, '2024-11-17 12:30'),(9, '2024-11-17 15:05'),
(10, '2024-11-17 15:10'),(11, '2024-11-17 15:15'),(12, '2024-11-17 15:15'),
(13, '2024-11-17 20:15'),(14, '2024-11-17 20:15');
```

### Expected Output


min_platforms_reqd | 
--|
4 | 


### Solution Query

```sql  
WITH train_traffic as (
    SELECT train_id, arrival_time as time, 1 as platforms
    FROM   train_arrivals
    UNION ALL
    SELECT train_id, departure_time, -1
    FROM   train_departures
    ORDER BY 2
)
,occupied_platforms as (
    SELECT time, SUM(platforms) OVER(ORDER BY time) as total_platforms_occupied  
    FROM   train_traffic
)
SELECT MAX(total_platforms_occupied) as min_platforms_reqd
FROM   occupied_platforms
```