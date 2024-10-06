### Problem Statement

You have two tables: `tracks` and `user_activity`.

- The `tracks` table stores information about music tracks.

- The `user_activity` table records user interactions with tracks.

    - The activity_type column represents different ways users can interact with tracks and stores values such as listen, like, share, or playlist_add.

    - The activity_value column represents the quantity of the activity. For listen activities, it represents the duration listened in seconds. For other activities, it stores the value 1.


### Schema Setup

```sql
CREATE TABLE tracks (
    track_id INT PRIMARY KEY,
    title VARCHAR(100),
    artist_name VARCHAR(100),
    duration_seconds INT,
    release_date DATE,
    genre VARCHAR(50)
);

INSERT INTO tracks (track_id, title, artist_name, duration_seconds, release_date, genre)
VALUES
  (1, 'Shape of You', 'Ed Sheeran', 233, '2017-01-06', 'Pop'),
  (2, 'Blinding Lights', 'The Weeknd', 200, '2019-11-29', 'Synth-pop'),
  (3, 'Dance Monkey', 'Tones and I', 209, '2019-05-10', 'Electropop'),
  (4, 'Levitating', 'Dua Lipa', 203, '2020-03-27', 'Pop'),
  (5, 'Watermelon Sugar', 'Harry Styles', 174, '2019-11-16', 'Pop'),
  (6, 'Savage Love', 'Jawsh 685', 177, '2020-06-11', 'Pop'),
  (7, 'Rockstar', 'DaBaby', 181, '2020-04-17', 'Hip-Hop'),
  (8, 'Mood', '24kGoldn', 140, '2020-07-24', 'Hip-Hop'),
  (9, 'Life Goes On', 'BTS', 215, '2020-11-20', 'K-Pop'),
  (10, 'Dynamite', 'BTS', 199, '2020-08-21', 'K-Pop'),
  (11, 'Peaches', 'Justin Bieber', 198, '2021-03-19', 'R&B'),
  (12, 'Kiss Me More', 'Doja Cat', 208, '2021-04-09', 'R&B'),
  (13, 'Good 4 U', 'Olivia Rodrigo', 178, '2021-05-14', 'Pop-Rock'),
  (14, 'Montero', 'Lil Nas X', 137, '2021-03-26', 'Hip-Hop'),
  (15, 'drivers license', 'Olivia Rodrigo', 242, '2021-01-08', 'Pop');
```

```sql
CREATE TABLE user_activity (
    activity_id INT PRIMARY KEY,
    user_id INT,
    track_id INT,
    activity_type VARCHAR(20),
    activity_date DATE,
    activity_value INT,
    FOREIGN KEY (track_id) REFERENCES tracks(track_id)
);

INSERT INTO user_activity (activity_id, user_id, track_id, activity_type, activity_date, activity_value)
VALUES
  (1, 101, 1, 'listen', '2023-08-18', 220),
  (2, 101, 1, 'like', '2023-08-18', 1),
  (3, 102, 2, 'listen', '2023-08-19', 195),
  (4, 102, 2, 'share', '2023-08-19', 1),
  (5, 103, 3, 'listen', '2023-08-20', 209),
  (6, 103, 1, 'playlist_add', '2023-08-20', 1),
  (7, 101, 4, 'listen', '2023-08-21', 180),
  (8, 101, 5, 'listen', '2023-08-21', 220),
  (9, 101, 5, 'like', '2023-08-21', 1),
  (10, 101, 7, 'listen', '2023-08-22', 200),
  (11, 102, 8, 'listen', '2023-08-22', 150),
  (12, 102, 9, 'listen', '2023-08-23', 200),
  (13, 102, 10, 'like', '2023-08-23', 1),
  (14, 102, 11, 'playlist_add', '2023-08-24', 1),
  (15, 103, 12, 'listen', '2023-08-24', 205),
  (16, 103, 13, 'like', '2023-08-24', 1),
  (17, 103, 13, 'share', '2023-08-24', 1),
  (18, 103, 14, 'listen', '2023-08-25', 175),
  (19, 104, 6, 'listen', '2023-08-25', 180),
  (20, 104, 15, 'like', '2023-08-25', 1),
  (21, 104, 12, 'listen', '2023-08-26', 190),
  (22, 104, 9, 'playlist_add', '2023-08-26', 1),
  (23, 105, 11, 'listen', '2023-08-27', 210),
  (24, 105, 5, 'listen', '2023-08-27', 170),
  (25, 105, 5, 'like', '2023-08-27', 1),
  (26, 105, 8, 'playlist_add', '2023-08-27', 1);
```


--- 

## Questions + Difficulty

### a. Easy

List the top 5 tracks by total listen duration, showing the track title, artist name, and total listen duration in hours.

#### Solution Query

```sql
SELECT   title, 
         artist_name, 
         ROUND(SUM(activity_value) / 3600.0, 4) AS total_listen_hours
FROM     tracks t JOIN user_activity ua USING (track_id)
WHERE    activity_type = 'listen'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT    5
```

---


### b. Intermediate

For each genre, find the artist with the most liked track. Display the genre, artist name, track title, and number of likes.

#### Solution Query

```sql
WITH genre_artist_likes as (
    SELECT   genre, 
             artist_name, 
             title,
             COUNT(track_id) FILTER(WHERE activity_type='like') as like_count,
             ROW_NUMBER() OVER(PARTITION BY genre ORDER BY COUNT(ua.track_id) FILTER(WHERE activity_type = 'like') DESC) AS rn
    FROM     tracks t JOIN user_activity ua USING (track_id)
    GROUP BY 1, 2, 3
)
SELECT genre, artist_name, title, like_count
FROM   genre_artist_likes
WHERE  rn = 1
```

---


### c. Advanced

Find pairs of tracks that are often listened to together in the same day by the same user. Display the pairs of track titles, their artists, and the count of users who listened to both tracks on the same day.


#### Solution Query

```sql
SELECT   t1.title AS track_title_1, 
         t1.artist_name AS artist_1,
         t2.title AS track_title_2, 
         t2.artist_name AS artist_2,
         COUNT(DISTINCT ua1.user_id) AS user_count
FROM     user_activity ua1 JOIN user_activity ua2 ON ua1.user_id = ua2.user_id 
                                                 AND ua1.activity_date = ua2.activity_date 
                                                 AND ua1.track_id < ua2.track_id 
                           JOIN tracks t1 ON ua1.track_id = t1.track_id
                           JOIN tracks t2 ON ua2.track_id = t2.track_id
WHERE    ua1.activity_type = 'listen' AND ua2.activity_type = 'listen'
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC
```

---

### d. Expert

Identify potential "super-spreader" users and tracks for a viral marketing campaign to maximize reach and engagement.


A. **Super-spreader users** --> users who engage with the most tracks throught various activity types like: `like`, `listen`, `playlist_add` & `share`


#### Solution Query

```sql
SELECT   ua.user_id,
         COUNT(DISTINCT ua.track_id) AS unique_tracks_engaged,
         COUNT(CASE WHEN ua.activity_type = 'share' THEN 1 END) AS total_shares,
         COUNT(CASE WHEN ua.activity_type = 'playlist_add' THEN 1 END) AS total_playlist_adds,
         COUNT(*) AS total_engagement
FROM     user_activity ua
GROUP BY 1
ORDER BY 5 DESC, 2 DESC, 3 DESC, 4 DESC
LIMIT    10


-- NOTE: can also do this by executing a CTE and setting thresholds for each COUNT() statements --> this seems the better way.
```


B. **Super-spreader tracks** --> tracks who receive highest engagement from distinct users.


#### Solution Query

```sql
SELECT   t.track_id,
         t.title,
         t.artist_name,
         COUNT(DISTINCT ua.user_id) AS unique_users_engaged,
         COUNT(CASE WHEN ua.activity_type = 'listen' THEN 1 END) AS total_listens,
         COUNT(CASE WHEN ua.activity_type = 'like' THEN 1 END) AS total_likes,
         COUNT(CASE WHEN ua.activity_type = 'share' THEN 1 END) AS total_shares,
         COUNT(CASE WHEN ua.activity_type = 'playlist_add' THEN 1 END) AS total_playlist_adds,
         COUNT(*) AS total_engagment
FROM     tracks t JOIN user_activity ua USING(track_id)
GROUP BY 1, 2, 3
ORDER BY 9 DESC, 5 DESC, 6 DESC, 7 DESC
LIMIT    10


-- NOTE: same can be done here too.
```