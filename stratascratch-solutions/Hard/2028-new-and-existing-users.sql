WITH monthly_users AS (
    SELECT   EXTRACT(MONTH FROM time_id) AS month,
             COUNT(user_id) AS user_count
    FROM     fact_events
    GROUP BY 1
    ORDER BY 1
),
first_month_users AS (
    SELECT   user_id,
             MIN(time_id) AS first_month_as_user
    FROM     fact_events
    GROUP BY 1
), 
new_users AS (
    SELECT   EXTRACT(MONTH FROM first_month_as_user) AS first_month,
             COUNT(DISTINCT user_id) AS total_users
    FROM     first_month_users
    GROUP BY 1
    ORDER BY 1
)
SELECT m.month,
       (total_users / user_count::DECIMAL) AS share_new_users,
       1 - (total_users / user_count::DECIMAL) AS share_existing_users
FROM   monthly_users m JOIN new_users n ON m.month = n.first_month

