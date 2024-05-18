## 11 Bumble SQL Interview Questions


### 1. Analyzing Bumble's Power Users

For a dating application like Bumble, a power user might be defined as someone who is very actively using the app. This can mean they are swiping a lot, having many matches, and engaging in conversations frequently. 

Let's define a Bumble power user as someone who has **more than 50 swipes, more than 10 matches, and over 10 conversations in a week.**

Given two tables, `user_activity` and `user_matches`, write a SQL query to find all power users for the week of '2022-06-01' to '2022-06-07'.

`user_activity` **Example Input:**

| activity_id | user_id | activity_date | swipes | conversations |
|-------------|---------|---------------|--------|---------------|
| 101         | 123     | 2022-06-01    | 70     | 15            |
| 102         | 456     | 2022-06-01    | 40     | 9             |
| 103         | 789     | 2022-06-02    | 60     | 12            |
| 104         | 321     | 2022-06-04    | 55     | 11            |
| 105         | 654     | 2022-06-07    | 45     | 8             |

`user_matches` **Example Input:**

| match_id | user_id | match_date | matches |
|----------|---------|------------|---------|
| 201      | 123     | 2022-06-01 | 12      |
| 202      | 456     | 2022-06-02 | 8       |
| 203      | 789     | 2022-06-03 | 15      |
| 204      | 321     | 2022-06-05 | 11      |
| 205      | 654     | 2022-06-07 | 9       |

**Answer:**

```sql
SELECT a.user_id
FROM   user_activity a JOIN user_matches m USING(user_id)
WHERE  a.activity_date >= '2022-06-01' AND a.activity_date <= '2022-06-07' AND 
       m.match_date >= '2022-06-01' AND m.match_date <= '2022-06-07' AND
       a.swipes > 50 AND 
       a.conversations > 10 AND 
       m.matches > 10;
```

---

### 2. User Swipe Analysis

Bumble wants to understand the swipe behavior of its users. You're provided with a dataset that represents swipe actions of various users throughout the day. 

The dataset contains the following information: user id, time of swipe, and the action (like, pass).

**Write a query to find the average number of swipe actions per hour for each user within a specified time frame.** 

Note that, given the dynamic nature of user interactions on the application, some users may not have any swipes within the specified time frame.

`swipes` **Example Input:**

| swipe_id | user_id | swipe_time          | action |
|----------|---------|----------------------|--------|
| 1001     | 123     | 2022-07-01 14:15:00 | Like   |
| 1002     | 123     | 2022-07-01 14:30:00 | Pass   |
| 1003     | 265     | 2022-07-01 23:45:00 | Like   |
| 1004     | 362     | 2022-07-02 16:00:00 | Pass   |
| 1005     | 123     | 2022-07-02 14:15:00 | Like   |

**Answer:**

```sql
-- was not able to solve on own.
-- plus, couldnt understand the solution provided.
```



---

### 3. In the context of a database transaction, what does ACID mean?

A DBMS (database management system), in order to ensure transactions are reliable and don't ruin the integrity of the data, tries to maintain the following ACID properties: Atomicity, Consistency, Isolation, and Durability.

To make this concept more concrete, here is what each of the ACID properties would mean in the context of banking transactions:

**Atomicity:** a transaction is either completed fully, or not complete at all. For example, if a customer is transferring money from one account to another, the transaction should either transfer the full amount or none at all.

**Consistency:** a transaction will only be completed if it follows all database constraints and checks. For example, if a customer is withdrawing money from an account, the transaction should only be completed if the account has sufficient funds available, otherwise the transaction is rejected.

**Isolation:** ensures that concurrent transactions are isolated from each other, so that the changes made by one transaction cannot be seen by another transaction. This isolation prevents race conditions, like two customers trying to withdraw money from the same account at the same time.

**Durability:** ensures that once a transaction has been committed and completed, the changes are permanent. A reset / shutdown of the database shouldn't erase someone's savings accounts!

---

### 4. Analyzing Bumble Date Interactions

Provided the business problem facing Bumble is to analyze and understand the impact of a user activity on match effectiveness. Let's consider two data tables: `users` and `matches`.

The `users` table records the user's information such as ID, gender, premium_status (Premium or Non-Premium). 

The `matches` table records details of every match made on the app, the initiator user, the pair user, the match date, and if a conversation was initiated.

`users` **Example Input:**

| user_id | gender | premium_status |
|---------|--------|----------------|
| 101     | Male   | Premium        |
| 102     | Female | Non-Premium    |
| 103     | Female | Premium        |
| 104     | Male   | Non-Premium    |
| 105     | Male   | Premium        |


`matches` **Example Input:**

| match_id | initiator_id | pair_id | match_date | conversation_started |
|----------|--------------|---------|------------|----------------------|
| 10       | 101          | 102     | 2022-07-01 | Yes                  |
| 11       | 103          | 104     | 2022-07-03 | No                   |
| 12       | 105          | 103     | 2022-07-05 | Yes                  |
| 13       | 102          | 105     | 2022-07-06 | No                   |
| 14       | 104          | 101     | 2022-08-01 | Yes                  |

**Calculate the conversation initiation rate for Premium and Non-Premium users on Bumble app for the month of July 2022.**

**Example Output:**

| month | premium_status | conversation_initiation_rate |
|-------|-----------------|----------------------------|
| July  | Premium        | 0.67                       |
| July  | Non-Premium    | 0.00                       |

**Answer:**

```sql
SELECT   EXTRACT(MONTH FROM match_date) as month, 
         premium_status, 
         ROUND(1.0 * COUNT(user_id) FILTER(WHERE conversation_started='Yes') / COUNT(*), 2) AS   conversation_initiation_rate
FROM     users u JOIN matches m ON u.user_id=m.initiator_id
WHERE    EXTRACT(MONTH FROM match_date)='7'
GROUP BY 1, 2
```


---

### 5. What's the difference between a one-to-one and one-to-many relationship?

In database schema design, a **one-to-one relationship** is when each entity is associated with only one instance of the other. For instance, a US citizen's relationship with their social-security number (SSN) is one-to-one because each citizen can only have one SSN, and each SSN belongs to one person.

A **one-to-many relationship**, on the other hand, is when one entity can be associated with multiple instances of the other entity. An example of this is the relationship between a person and their email addresses - one person can have multiple email addresses, but each email address only belongs to one person.

---

### 6. Filter Bumble Users Based on Age, Gender and Last Active 

As a Data Analyst at Bumble, you are tasked to filter out active male users who are above 30 years old from the `users` table. Active users are defined as those who have last logged in within the past month.

The `users` table contains the following sample data:

`users` **Example Input:**

| user_id | last_login | age | gender |
|---------|------------|-----|--------|
| 1111    | 2022-06-08 | 25  | male   |
| 1112    | 2022-06-10 | 35  | male   |
| 1113    | 2022-06-18 | 32  | female |
| 1114    | 2022-07-26 | 31  | male   |
| 1115    | 2022-08-05 | 33  | male   |

**Answer:**

```sql
SELECT * 
FROM   users 
WHERE  age > 30 AND 
       gender = 'male' AND 
       last_login > (CURRENT_DATE - INTERVAL '1 month');
```

---


### 7. Can you explain what MINUS / EXCEPT SQL commands do?

For a tangible example of `EXCEPT` in PostgreSQL, suppose you were doing an HR Analytics project for Bumble, and had access to Bumble's contractors and employees data. Assume that some employees were previously contractors, and vice versa, and thus would show up in both tables.

You could use `EXCEPT` operator to find all contractors who never were an employee using this query:

```sql
SELECT first_name, last_name
FROM bumble_contractors

EXCEPT

SELECT first_name, last_name
FROM bumble_employees
```

Note that `EXCEPT` is available in PostgreSQL and SQL Server, while `MINUS` is the equivalent operator which is available in MySQL and Oracle (but don't worry about knowing which RDBMS supports which exact commands since Bumble interviewers aren't trying to trip you up on memorizing SQL syntax).

---

### 8. Average Messaging Activity on Bumble

As an analyst for Bumble, you've been asked to monitor the use of the platform by **calculating the average number of messages sent per user each month**. This can give insights on user engagement and help shape policies to drive up user interaction.

`messages` **Example Input:**

| message_id | sender_id | receiver_id | message_date        | content        |
|------------|-----------|-------------|----------------------|-----------------|
| 9842       | 145       | 238         | 06/01/2022 14:00:00 | Hello there!    |
| 8417       | 102       | 365         | 06/03/2022 16:30:00 | How's your day? |
| 6729       | 145       | 238         | 06/05/2022 10:11:00 | Let's meet up.  |
| 7290       | 238       | 145         | 06/06/2022 18:22:00 | Sure, let's do it. |
| 9983       | 102       | 365         | 07/02/2022 20:45:00 | Sorry, got busy.|

**Example Output:**

| month | avg_messages_sent |
|-------|-------------------|
| 6     | 1.5               |
| 7     | 1.0               |

**Answer:**

```sql
WITH msg_count_cte as (
       SELECT   EXTRACT(MONTH FROM message_date) as month, 
                sender_id,
                COUNT(message_id) as messages_count
       FROM     messages
       GROUP BY 1, 2
)
SELECT   month, 
         ROUND(AVG(messages_count), 1) as avg_messages_sent
FROM     msg_count_cte
GROUP BY 1
```


---

### 9. Click-through-rate (CTR) Calculation for Bumble

Bumble is a dating app where users 'swipe right' or 'swipe left' on other user profiles. If they like someone, they swipe right, showing interest. 

However, having a match (when two users like each other) is not the end, it's vital to move a conversation beyond just matching. 

Assume Bumble wants to analyze click-through-rate from viewing to initiating a conversation.


Consider the following tables:

- `swipes`: This table records each swipe done by a user. The `swipe_direction` column will have values "right" for like and "left" for dislike.

- `conversations`: This table holds the records of users who initiated a conversation after a match.

`swipes` **Example Input:**

| swipe_id | user_id | date_time           | profile_id | swipe_direction |
|----------|---------|----------------------|------------|-----------------|
| 1        | 101     | 06/01/2022 08:15:00 | 2301       | "right"         |
| 2        | 324     | 06/01/2022 08:16:00 | 2376       | "left"          |
| 3        | 434     | 06/01/2022 08:18:00 | 2391       | "right"         |
| 4        | 219     | 06/01/2022 08:21:00 | 2450       | "right"         |
| 5        | 101     | 06/01/2022 08:25:00 | 2386       | "left"          |

`conversations` **Example Input:**

| conversation_id | initiator_id | receiver_id | start_date_time     |
|-----------------|--------------|-------------|----------------------|
| 1               | 101          | 2301        | 06/01/2022 10:12:00 |
| 2               | 324          | 2376        | 06/01/2022 11:16:00 |
| 3               | 219          | 2450        | 06/02/2022 08:18:00 |

Please calculate the click-through-rate as the number of conversations begun after a mutual match (a pair exists in both `swipes` and `conversations` tables) over the total swipes made.

**Answer:**


```sql
WITH total_swipes AS (
       SELECT COUNT(*) AS total
       FROM   public.swipes
       WHERE  swipe_direction = 'right'
),
conversations_started AS (
       SELECT COUNT(*) AS conversation_total
       FROM   public.swipes AS s JOIN public.conversations AS c ON (s.user_id = c.initiator_id AND s.profile_id = c.receiver_id)
       WHERE  s.swipe_direction = 'right'
)
SELECT 100.0 * conversations_started.conversation_total::decimal / total_swipes.total::decimal AS click_through_rate
FROM   total_swipes, conversations_started;
```

---

### 10. What is normalization?

Normalizing a database involves dividing a large table into smaller and more specialized ones, and establishing relationships between them using foreign keys. 

This reduces repetition, resulting in a database that is more adaptable, scalable, and easy to maintain.

Additionally, it helps to preserve the accuracy of the data by reducing the likelihood of inconsistencies and problems.

---

### 11. Find the average number of matches per user per month

Bumble is a dating app where users can like and match with each other. 

The goal of this question is to **find the average number of matches each user made per month over the entire lifetime of their account**.

Consider the `users` and `matches` tables below:

`users` **Example Input:**

| user_id | registration_date |
|---------|-------------------|
| 123     | 2017-06-12        |
| 265     | 2017-10-05        |
| 362     | 2018-01-18        |
| 192     | 2018-07-26        |
| 981     | 2018-11-21        |

`matches` **Example Input:**

| match_id | user_id | match_date |
|----------|---------|------------|
| 1        | 123     | 2017-09-02 |
| 2        | 123     | 2017-10-04 |
| 3        | 123     | 2017-11-07 |
| 4        | 265     | 2017-10-07 |
| 5        | 265     | 2017-11-08 |
| 6        | 265     | 2017-11-10 |
| 7        | 362     | 2018-04-12 |
| 8        | 362     | 2018-05-14 |
| 9        | 192     | 2018-09-22 |
| 10       | 981     | 2018-12-12 |

**Answer:**

```sql
SELECT   EXTRACT(YEAR FROM registration_date) AS year,
         EXTRACT(MONTH FROM registration_date) AS month,
         u.user_id, 
         COUNT(m.match_id) / COUNT(DISTINCT u.user_id) :: DECIMAL AS avg_matches_per_user
FROM     users u JOIN matches m USING(user_id)
WHERE    m.match_date >= u.registration_date
GROUP BY 1, 2, 3
ORDER BY 1, 2, 4 DESC
```

---