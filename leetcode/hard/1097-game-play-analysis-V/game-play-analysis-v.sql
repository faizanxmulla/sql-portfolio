WITH first_login_cte AS (
    SELECT   player_id, MIN(event_date) AS first_login
    FROM     activity
    GROUP BY 1
),
next_day_login_cte AS (
    SELECT fl.player_id, 
           first_login, 
           (CASE 
               WHEN a.event_date = first_login + INTERVAL '1 DAY'
               THEN 1 ELSE 0 
             END) AS next_day_login
    FROM    first_login_cte fl LEFT JOIN Activity a ON fl.player_id = a.player_id AND a.event_date = first_login + INTERVAL '1 DAY'
),
installs_cte AS (
    SELECT   first_login, COUNT(player_id) AS installs
    FROM     first_login_cte
    GROUP BY 1
),
retention_cte AS (
    SELECT   first_login, SUM(next_day_login) AS retained
    FROM     next_day_login_cte
    GROUP BY 1
)
SELECT   i.first_login AS install_dt, 
         i.installs, 
         ROUND(COALESCE(r.retained, 0) / i.installs, 2) AS day1_retention
FROM     installs_cte i LEFT JOIN retention_cte r USING(first_login)
ORDER BY 1