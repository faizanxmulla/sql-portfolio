### Problem Statement | [Leetcode Link](https://leetcode.com/problems/user-purchase-platform/description/)

Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.


### Schema Setup

```sql
CREATE TABLE user_spend (
    user_id INT,
    spend_date DATE,
    platform VARCHAR(10),
    amount INT
);

INSERT INTO user_spend (user_id, spend_date, platform, amount) VALUES
(1, '2019-07-01', 'mobile', 100),
(1, '2019-07-01', 'desktop', 100),
(2, '2019-07-01', 'mobile', 100),
(2, '2019-07-02', 'mobile', 100),
(3, '2019-07-01', 'desktop', 100),
(3, '2019-07-02', 'desktop', 100);
```


### Expected Output

| spend_date | platform | total_amount | total_users |
|------------|----------|--------------|-------------|
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |


### Solution Query

```sql
WITH user_platform_usage AS (
    SELECT   spend_date,
             user_id,
             SUM(CASE WHEN platform = 'desktop' THEN 1 ELSE 0 END) AS desktop_count,
             SUM(CASE WHEN platform = 'mobile' THEN 1 ELSE 0 END) AS mobile_count,
             SUM(CASE WHEN platform = 'desktop' THEN amount ELSE 0 END) AS desktop_amount,
             SUM(CASE WHEN platform = 'mobile' THEN amount ELSE 0 END) AS mobile_amount
    FROM     user_spend
    GROUP BY 1, 2
),
platform_summary AS (
    SELECT   spend_date,
             'desktop' AS platform,
             SUM(desktop_amount) AS total_amount,
             COUNT(CASE WHEN desktop_count > 0 AND mobile_count = 0 THEN 1 ELSE NULL END) AS total_users
    FROM     user_platform_usage
    GROUP BY 1
    UNION ALL
    SELECT   spend_date,
             'mobile' AS platform,
             SUM(mobile_amount) AS total_amount,
             COUNT(CASE WHEN mobile_count > 0 AND desktop_count = 0 THEN 1 ELSE NULL END) AS total_users
    FROM     user_platform_usage
    GROUP BY 1
    UNION ALL
    SELECT   spend_date,
             'both' AS platform,
             SUM(desktop_amount + mobile_amount) AS total_amount,
             COUNT(CASE WHEN desktop_count > 0 AND mobile_count > 0 THEN 1 ELSE NULL END) AS total_users
    FROM     user_platform_usage
    GROUP BY 1
)
SELECT   spend_date, platform, total_amount, total_users
FROM     platform_summary
ORDER BY 1, 2 desc
```
