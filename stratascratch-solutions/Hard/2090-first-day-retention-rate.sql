WITH first_user_logins AS (
    SELECT   player_id, login_date, MIN(login_date) as first_login_date
    FROM     players_logins
    GROUP BY 1, 2
    ORDER BY 1
),
login_after_first_day AS (
    SELECT player_id, 
           first_login_date, 
           LEAD(first_login_date) OVER(PARTITION BY player_id ORDER BY login_date) as second_login_date
    FROM   first_user_logins
)
SELECT COUNT(player_id) FILTER(WHERE second_login_date - first_login_date = 1) * 1.0 / 
       COUNT(player_id) AS retained_users_proportion
FROM   login_after_first_day