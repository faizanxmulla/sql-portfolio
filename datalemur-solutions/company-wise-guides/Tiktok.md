## 10 TikTok SQL Interview Questions


### 1. TikTok Sign-Up Activation Rate

Assume new TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table. 

**Write a SQL query to find the activation rate percentage, and round your answer to 2 decimal places.**

**Definitions:**
- `emails` table contains the information of user signup details.

- `texts` table contains the users' activation information.

**Assumptions:**
- The analyst is interested in the activation rate of specific users in the `emails` table, which may not include all users that could potentially be found in the `texts` table.

- For example, user 123 in the `emails` table may not be in the `texts` table and vice versa.

**Example Input:**

`emails` table:

| email_id | user_id | signup_date |
|----------|---------|-------------|
| 125      | 7771    | 06/14/2022  |
| 236      | 6950    | 07/01/2022  |  
| 433      | 1052    | 07/09/2022  |

`texts` table: 

| text_id | email_id | signup_action |
|---------|----------|----------------|
| 6878    | 125      | Confirmed      |
| 6920    | 236      | Not Confirmed  |
| 6994    | 236      | Confirmed      |

'Confirmed' in `signup_action` means the user has activated their account and successfully completed the signup process.

**Example Output:**
| confirm_rate |
|--------------|
| 0.67         |

**Explanation:** 67% of users have successfully completed their signup and activated their accounts. The remaining 33% have not yet replied to the text to confirm their signup.

**Answer:**

```sql
SELECT ROUND(COUNT(t.email_id)::decimal / COUNT(DISTINCT e.email_id), 2) AS activation_rate
FROM   emails e LEFT JOIN texts t USING(email_id) 
WHERE  t.signup_action = 'Confirmed';
```

---

### 2. Identify TikTok's Most Active Users

As a Data Analyst for TikTok, you've been asked to identify the users who are the most active on the platform. "Activity" in this context is defined by the number of videos a user uploads.

A "power user" is someone who has uploaded more than 1000 videos. 

**Write a SQL query to list all of the power users, sorted by the number of videos they have posted in descending order.**

**Example Input:**

`Users` table:

| user_id | username   | signup_date |
|---------|------------|-------------|
| 1       | user1      | 01/01/2020  |
| 2       | user2      | 02/02/2020  |
| 3       | user3      | 05/05/2020  |
| 4       | user4      | 12/12/2020  |

`Videos` table:

| video_id | user_id | upload_date |
|----------|---------|-------------|
| 1001     | 1       | 01/02/2020  |
| 1002     | 1       | 01/03/2020  |
| 1003     | 2       | 02/03/2020  |
| 1004     | 3       | 03/03/2020  |
| 1005     | 4       | 04/04/2020  |
| 1006     | 4       | 05/04/2020  |
| 1007     | 4       | 05/04/2020  |
| 1008     | 4       | 05/04/2020  |
| 1009     | 3       | 06/04/2020  |
| 1010     | 2       | 07/07/2020  |

**Answer:**

```sql
SELECT   u.username, COUNT(v.video_id) as num_videos 
FROM     Users u JOIN Videos v USING(user_id)
GROUP BY 1
HAVING   COUNT(v.video_id) > 1000 
ORDER BY 2 DESC;
```

---

### 3. One-to-One vs One-to-Many Relationship


**Answer:** 

In database schema design, a `one-to-one relationship` is when each entity is associated with only one instance of the other. 

For instance, a US citizen's relationship with their social-security number (SSN) is one-to-one because each citizen can only have one SSN, and each SSN belongs to one person.

A `one-to-many relationship`, on the other hand, is when one entity can be associated with multiple instances of the other entity. 

An example of this is the relationship between a person and their email addresses - one person can have multiple email addresses, but each email address only belongs to one person.

---


### 4. Second Day Confirmation  

New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account. 

**Write a SQL query to output the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.**

**Example Input:**

`emails` table:

| email_id | user_id | signup_date |
|----------|---------|-------------|
| 125      | 7771    | 06/14/2022  | 
| 433      | 1052    | 07/09/2022  |

`texts` table:

| text_id | email_id | signup_action | action_date |
|---------|----------|----------------|-------------|
| 6878    | 125      | Confirmed      | 06/14/2022  |
| 6997    | 433      | Not Confirmed  | 07/09/2022  |
| 7000    | 433      | Confirmed      | 07/10/2022  |

Note: `action_date` refers to the date when users activated their accounts and confirmed their sign-up through text messages.

**Example Output:**

| user_id |
|---------|
| 1052    |



**Answer:**

```sql
SELECT DISTINCT user_id
FROM   emails e JOIN t texts USING(email_id)
WHERE  t.action_date = e.signup_date + INTERVAL '1 day' AND t.signup_action = 'Confirmed';
```

---

### 5. What's a database view?

**Answer:**
A database view is a virtual table that is created based on the results of a `SELECT` statement, and provides you a customized, read-only version of your data that you can query just like a regular table.

You'd want to use a view for a few reasons:

- Views allow you to create simpler versions of your data based on whose running the query (such as hiding un-important columns/rows from business analysts if they're just random noisy artifacts of your Data Infrastructure pipelines).

- Views can help you comply with information security requirements by hiding sensitive data from certain users (important for regulated industries like government and healthcare!).

- Views often improve performance for complicated queries by pre-computing the results and saving them in a view (which is often faster than re-executing the original query)... just be careful since static views don't update if the underlying data changes!


---

### 6. Calculate Average Video Duration on TikTok

On TikTok, each user can post several videos. For business decisions, it's often necessary to know the average duration of these videos to better understand the user engagement. For instance, if the average video duration is short, it could indicate that users on the platform prefer shorter, more concise content. 

Alternatively, longer average video lengths could infer that users enjoy or are more engaged with longer-form content. 

**Calculate the average video duration for each TikTok user using the provided database tables.**


**Example Input:**

`users` table:

| user_id | username | signup_date |
|---------|----------|-------------|
| 101     | user1    | 06/01/2020  |
| 102     | user2    | 06/03/2020  |
| 103     | user3    | 06/05/2020  |

`videos` table:

| video_id | user_id | upload_date | video_length_seconds |
|----------|---------|-------------|-----------------------|
| 201      | 101     | 06/08/2022  | 60                   |
| 202      | 101     | 06/10/2022  | 120                  |
| 203      | 102     | 06/18/2022  | 90                   |
| 204      | 103     | 07/26/2022  | 100                  |
| 205      | 103     | 07/05/2022  | 120                  |

**Answer:**

```sql
SELECT   username, AVG(video_length_seconds) AS avg_video_duration_seconds 
FROM     videos v JOIN users u USING(user_id)
GROUP BY 1
```


---

### 7. In SQL, Are NULL values the same as a zero or blank space?

**Answer:**
NULLs are NOT the same as zero or blank spaces in SQL. NULLs are used to represent a missing value or the absence of a value, whereas zero and blank space are legitimate values.

It's important to handle NULLs carefully, because they can mess up your analysis very easily. For example, if you compare a NULL value using the `=` operator, the result will always be NULL (because just like Drake, nothing be dared compared to NULL). That's why many data analysis in SQL start with removing NULLs using the `COALESCE()` function.

---

### 8. Analyzing User Behavior and Content Interactions on TikTok

You have been given access to the TikTok database and you are tasked with the following:

TikTok has two primary tables -- `Users` and `Videos`. Each row in the `Users` table represents a unique user on the platform, while each row in the `Videos` table represents a unique video that has been uploaded on the platform. A video can be uploaded by a user, and the same user can 'like' or 'share' other videos, including their own.

**Write a SQL query that shows the top 5 Users who have uploaded the videos that have received the most 'likes'.** 

The output should display the User ID, the total number of videos they have uploaded, and the total number of 'likes' their videos have collectively received.

**Example Input:**

`Users` table:

| user_id | username | country | join_date |
|---------|----------|---------|------------|
| 1       | user1    | USA     | 2021-01-01 |
| 2       | user2    | Canada  | 2021-02-01 |
| 3       | user3    | UK      | 2021-01-31 |
| 4       | user4    | USA     | 2021-01-30 |
| 5       | user5    | Canada  | 2021-01-15 |

`Videos` table: 

| video_id | upload_date | user_id | video_likes |
|----------|--------------|---------|-------------|
| 101      | 2021-01-01   | 1       | 500         |
| 102      | 2021-02-01   | 2       | 1000        |
| 103      | 2021-02-01   | 1       | 1500        |
| 104      | 2021-03-01   | 3       | 2000        |
| 105      | 2021-03-01   | 4       | 250         |
| 106      | 2021-04-01   | 5       | 5000        |

**Answer:**

```sql
SELECT   user_id, 
         COUNT(video_id) AS total_videos, 
         SUM(video_likes) AS total_likes
FROM     Users u JOIN Videos v USING(user_id)
GROUP BY 1
ORDER BY 3 DESC
LIMIT    5;
```



---

### 9. Video Interaction Analysis

Using the data from the video and user interactions on TikTok, calculate the average, maximum, and minimum durations of videos watched by users, rounded to the nearest whole number. 

Additionally, calculate the square root of the total number of likes given by users and present it as `totalLikesSQRT`. Assume we only have data for a single day.

**Example Input:**

`videos` table:

| video_id | duration_secs |
|----------|----------------|
| 001      | 60             |
| 002      | 45             |
| 003      | 75             |
| 004      | 120            |
| 005      | 30             |

`user_watched_videos` table:

| user_id | video_id | watched_duration_secs |
|---------|----------|------------------------|
| 123     | 001      | 60                     |
| 265     | 002      | 30                     |
| 362     | 003      | 55                     |
| 192     | 004      | 120                    |
| 981     | 005      | 25                     |

`user_likes` table:

| user_id | video_id | liked |
|---------|----------|-------|
| 123     | 001      | TRUE  |
| 265     | 002      | FALSE |
| 362     | 003      | TRUE  |
| 192     | 004      | TRUE  |
| 981     | 005      | TRUE  |

**Example Output:**

| avg_watched_duration | max_watched_duration | min_watched_duration | totalLikesSQRT |
|----------------------|----------------------|----------------------|----------------|
| 58                   | 120                  | 25                   | 2              |

**Answer:**

```sql
SELECT ROUND(AVG(duration_secs)) as avg_duration, 
	   ROUND(MAX(duration_secs)) as max_duration, 
       ROUND(MIN(duration_secs)) as min_duration,
       SQRT(SUM(CASE WHEN liked THEN 1 ELSE 0 END)) as totalLikesSQRT
FROM   user_watched_videos wv JOIN user_likes l USING(video_id)
	                         JOIN videos USING(video_id)
```

---


### 10. Videos Engagement Analysis

You are working as a Data Analyst for TikTok. Some videos go viral suddenly after a period of time. Your task is to find for each `User_Id`, the video (`Video_Id`) with the Maximum number of likes (`Likes`) per day (`Date`). 

Note that some users might have multiple videos in a day, and the result needs to show only the first uploaded video in case of a tie on likes count.

**Example Input:**

`Video_Stats` table:

| User_Id | Video_Id | Date       | Likes |
|---------|----------|------------|-------|
| 101     | VV567    | 2022-10-01 | 150   |
| 101     | VV234    | 2022-10-01 | 80    |
| 101     | VV890    | 2022-10-01 | 150   |
| 102     | VV101    | 2022-10-01 | 300   |
| 102     | VV111    | 2022-10-01 | 200   |
| 101     | VV123    | 2022-10-02 | 100   |
| 101     | VV456    | 2022-10-02 | 120   |
| 102     | VV789    | 2022-10-02 | 500   |

**Answer:**

```sql
WITH max_likes_cte as (
	SELECT Date, User_id, Video_Id, RANK() OVER(PARTITION BY Date, User_id ORDER BY Likes DESC, Video_Id ) 
    FROM   Video_Stats 
)
SELECT   Date, User_id, Video_Id
FROM     max_likes_cte
WHERE    rank=1
ORDER BY 1, 2
```

---