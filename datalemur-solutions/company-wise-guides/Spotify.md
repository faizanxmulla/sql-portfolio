## 9 Spotify SQL Interview Questions

### 1. Identify Spotify's Most Frequent Listeners

Spotify wants to identify their 'whale users', these are users who listen to the most tracks every month. They are potential customers to involve in user feedback sessions. 

Given the database tables `users` and `user_listen_history`, write a SQL query to identify the top 5 users who have listened to the most unique tracks in the last 30 days. Assume today's date is 2023-03-22.

`users` **Example Input:**

| user_id | username | sign_up_date | email |
|---------|----------|--------------|-------|
| 1001    | user1    | 10/02/2021   | user1@gmail.com |
| 2002    | user2    | 22/05/2022   | user2@yahoo.com |
| 3003    | user3    | 01/01/2022   | user3@hotmail.com |
| 4004    | user4    | 15/07/2021   | user4@aol.com |
| 5005    | user5    | 24/12/2021   | user5@msn.com |

`user_listen_history` **Example Input:**

| listen_id | user_id | listen_date | track_id |
|-----------|---------|--------------|----------|
| 1         | 1001    | 02/03/2023   | 100      |
| 2         | 1001    | 02/03/2023   | 101      |
| 3         | 1001    | 03/03/2023   | 100      |
| 4         | 2002    | 03/03/2023   | 103      |
| 5         | 2002    | 03/03/2023   | 104      |
| 5         | 3003    | 03/03/2023   | 100      |
| 6         | 4004    | 03/03/2023   | 104      |
| 7         | 5005    | 03/03/2023   | 100      |

**Answer:**

```sql
SELECT   user_id, username, COUNT(DISTINCT track_id) as total_unique_tracks_listened
FROM     users u JOIN user_listen_history ulh USING(user_id)
WHERE    listen_date BETWEEN '2023-02-22' AND '2023-03-22'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT    5;
```

---

### 2. Analyze Artist Popularity Over Time

Let's assume you are a Data Analyst at Spotify. You are given a data table named `artist_listens` containing daily listening counts for different artists. The table has three columns: `artist_id`, `listen_date`, and `daily_listens`.

**Write a SQL query to calculate the 7-day rolling average of daily listens for each artist.** 

The rolling average should be calculated for each day for each artist based on the previous 7 days (including the current day).

`artist_listens` **Example Input:**

| artist_id | listen_date | daily_listens |
|-----------|-------------|---------------|
| 1         | 2022-06-01  | 15000         |
| 1         | 2022-06-02  | 21000         |
| 1         | 2022-06-03  | 17000         |
| 2         | 2022-06-01  | 25000         |
| 2         | 2022-06-02  | 27000         |
| 2         | 2022-06-03  | 29000         |

Notice that the `listen_date` column is date formatted.

**Example Output:**

| artist_id | listen_date | rolling_avg_listens |
|-----------|-------------|---------------------|
| 1         | 2022-06-01  | 15000.00            |
| 1         | 2022-06-02  | 18000.00            |
| 1         | 2022-06-03  | 17666.67            |
| 2         | 2022-06-01  | 25000.00            |
| 2         | 2022-06-02  | 26000.00            |
| 2         | 2022-06-03  | 27000.00            |

Please pay attention to the rounding in the result.

**Answer:**

```sql
WITH rolling_avg_cte as (
    SELECT artist_id, 
           listen_date, 
           AVG(daily_listens) OVER(PARTITION BY artist_id
                                   ORDER BY listen_date
                                   ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg
    FROM   artist_listens
)
SELECT artist_id, 
	   listen_date,
       ROUND(rolling_avg, 2) as rolling_avg_listens
FROM   rolling_avg_cte
```

---

### 3. What distinguishes an inner join from a full outer join?

A full outer join returns all rows from both tables, including any unmatched rows, whereas an inner join only returns rows that match the join condition between the two tables.

For an example of each one, say you had sales data exported from Spotify's Salesforce CRM stored in a datawarehouse which had two tables: `sales` and `spotify_customers`.

**INNER JOIN:** retrieves rows from both tables where there is a match in the shared key or keys.

```sql
SELECT *
FROM sales
INNER JOIN spotify_customers
ON sales.customer_id = spotify_customers.id
```

This query will return rows from the `sales` and `spotify_customers` tables that have matching `customer_id` values. Only rows with matching `customer_id` values will be included in the results.

**FULL OUTER JOIN:** retrieves all rows from both tables, regardless of whether there is a match in the shared key or keys. If there is no match, `NULL` values will be returned for the columns of the non-matching table.

Here is an example of a SQL full outer join using the `sales` and `spotify_customers` tables:

```sql
SELECT *
FROM sales
FULL OUTER JOIN spotify_customers
ON sales.customer_id = spotify_customers.id
```

---

### 4. Music Streaming Statistics

As a Data Analyst of Spotify, suppose your team is interested in understanding the listening habits of the users. You're provided with the following tables:

- `users` table contains information about users.

- `songs` table contains information about songs.
- `artists` table contains information about song artists.
- `streaming` table logs every song listened to by each user.

The following relationships hold:

- Every song has one and only one artist, but an artist can have multiple songs.
- Every song can be listened to by multiple users, and every user can listen to multiple songs.

**Write a SQL query that returns each user's favourite artist, based on the number of songs they've listened to by the artist.**

`users` **Example Input:**

| user_id | username | country |
|---------|----------|---------|
| 1       | user101  | USA     |
| 2       | user202  | UK      |
| 3       | user303  | Brazil  |

`songs` **Example Input:** 

| song_id | song_name | artist_id |
|---------|-----------|-----------|
| 101     | song101   | 1001      |
| 102     | song102   | 1002      |
| 103     | song103   | 1001      |

`artists` **Example Input:**

| artist_id | artist_name |
|-----------|-------------|
| 1001      | artist1001  |
| 1002      | artist1002  |

`streaming` **Example Input:**

| user_id | song_id | stream_time |
|---------|---------|-------------|
| 1       | 101     | 5:00        |
| 1       | 102     | 5:30        |
| 1       | 103     | 6:00        |
| 2       | 101     | 8:00        |
| 2       | 103     | 9:00        |
| 3       | 102     | 10:00       |

**Answer:**

```sql
SELECT u.username, a.artist_name 
FROM (
    SELECT   st.user_id, s.artist_id, COUNT(*) as num_songs
    FROM     streaming AS st JOIN songs s USING(song_id)
    GROUP BY 1, 2
    ORDER BY 3 DESC 
) AS x
JOIN  users u ON u.user_id = x.user_id
JOIN  artists a ON a.artist_id = x.artist_id
LIMIT 1;
```

---

### 5. What is denormalization?

Denormalization is a technique used to improve the read performance of a database, typically at the expense of some write performance. 

By adding redundant copies of data or grouping data together in a way that does not follow normalization rules, denormalization improves the performance and scalability of a database by eliminating costly join operations, which is important for OLAP use cases that are read-heavy and have minimal updates/inserts.

---

### 6. Filter Spotify Users Based on Subscription and Activity

As a data analyst at Spotify, you are tasked with extracting a list of active Premium subscribers who have listened to at least 15 different artists in the current month. 

Active users are those who have logged in within the last 30 days.

Assuming you have two tables:  

`users` **Example Input:**

| **user_id** | **subscription_status** | **last_login** |
|-------------|-------------------------|----------------|
| 1           | Premium                 | 2022-08-20     |
| 2           | Free                    | 2022-08-01     |
| 3           | Premium                 | 2022-07-30     |
| 4           | Premium                 | 2022-08-21     |

`activity` **Example Input:**

| **user_id** | **artist_name** | **month** |
|-------------|-----------------|------------|
| 1           | Artist 1        | August    |
| 1           | Artist 2        | August    |
| 1           | Artist 3        | August    |
| 2           | Artist 4        | August    |
| 1           | Artist 5        | August    |
| 1           | Artist 6        | August    |
| 1           | Artist 7        | August    |
| 1           | Artist 8        | August    |
| 1           | Artist 9        | August    |
| 1           | Artist 10       | August    |
| 1           | Artist 11       | August    |
| 1           | Artist 12       | August    |
| 1           | Artist 13       | August    |
| 1           | Artist 14       | August    |
| 1           | Artist 15       | August    |
| 3           | Artist 1        | July      |
| 4           | Artist 2        | August    |

**Answer:**

```sql
WITH active_users as (
    SELECT *
    FROM   users
    WHERE  last_login >= CURRENT_DATE - INTERVAL '30 DAYS'
)
SELECT   user_id, COUNT(DISTINCT artist_name) as artist_count
FROM     active_users au JOIN activity a USING(user_id)
WHERE    month='August' and subscription_status = 'Premium'
GROUP BY 1
HAVING   COUNT(DISTINCT artist_name) >= 15
```

---

### 7. What distinguishes a left join from a right join?

In SQL, a join generally retrieves rows from multiple tables and combines them into a single result set. For an example of the difference between a left vs. right join, suppose you had a table of Spotify orders and Spotify customers.

A **LEFT JOIN** retrieves all rows from the left table (in this case, the Orders table) and any matching rows from the right table (the Customers table). If there is no match in the right table, `NULL` values will be returned for the right table's columns.  

A **RIGHT JOIN** combines all rows from the right table (in this case, the Customers table) and any matching rows from the left table (the Orders table). If there is no match in the left table, `NULL` values will be displayed for the left table's columns.

---

### 8. Calculate the average listening duration for each music genre on Spotify

Suppose that Spotify would like to understand better the average listening duration for each genre of music on their platform. 

**Write a SQL query that calculates the average listening duration per genre for every month.**

Assume you have access to a `user_activity` table and a `songs` table with the following schema:

`user_activity` **Example Input:**

| activity_id | user_id | song_id | timestamp | listening_duration_sec |
|-------------|---------|---------|------------|------------------------|
| 1           | 101     | 5001    | 2022-03-01 09:00:00 | 210 |
| 2           | 102     | 6985    | 2022-03-01 11:30:00 | 120 |
| 3           | 103     | 5001    | 2022-03-01 15:45:00 | 300 |
| 4           | 101     | 6985    | 2022-04-01 08:45:00 | 180 |
| 5           | 102     | 5001    | 2022-04-01 10:00:00 | 240 |

`songs` **Example Input:**

| song_id | genre |
|---------|-------|
| 5001    | Rock  |
| 6985    | Pop   |

Your aim is to produce a table like:

**Example Output:**

| mth | genre | avg_listening_duration_sec |
|-----|-------|-----------------------------|
| 3   | Rock  | 255                         |
| 3   | Pop   | 120                         |
| 4   | Rock  | 240                         |
|4 |	Pop |	180 |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM timestamp) AS month,
         genre,
         AVG(listening_duration_sec) AS avg_listening_duration_sec
FROM     user_activity ua JOIN songs s USING(song_id)
GROUP BY 1, 2
```


---

### 9. Find Users Who've Listened to All Albums of a Specific Artist

As an analyst at Spotify, you're tasked to identify all users who have listened to all albums of the artist "Adele". 

Assume you have access to a `users` table that keeps track of user information and an `album_listens` table that keeps track of all instances where a user listened to an album. 

Here are the table structures:

`users` table

| user_id | user_name |
|---------|-----------|
| 1       | John      |
| 2       | Jane      |
| 3       | Alice     |

`album_listens` table

| listen_id | user_id | artist_name | album_name |
|-----------|---------|--------------|------------|
| 101       | 1       | Adele        | 19         |
| 102       | 1       | Adele        | 21         |
| 103       | 1       | Adele        | 25         |
| 104       | 2       | Adele        | 21         |
| 105       | 3       | Adele        | 21         |
| 106       | 3       | Adele        | 25         |

**Write a query to find all users who have listened to all Adele's albums (19, 21, 25).**

**Answer:**

```sql
SELECT   user_id, COUNT(DISTINCT listen_id) as listen_count
FROM     users u JOIN album_listens al USING(user_id)
WHERE    artist_name = 'Adele' AND album_name IN ('19', '21', '25')
GROUP BY 1
HAVING   COUNT(DISTINCT album_name) = 3;
```

---