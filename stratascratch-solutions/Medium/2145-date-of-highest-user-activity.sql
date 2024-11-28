WITH ranked_counts as (
    SELECT   date_visited,
             COUNT(DISTINCT user_id) as n_users,
             RANK() OVER(ORDER BY COUNT(DISTINCT user_id) desc) as rn
    FROM     user_streaks
    WHERE    date_visited BETWEEN '2022-08-01' and '2022-08-07'
    GROUP BY date_visited
)
SELECT TO_CHAR(date_visited, 'Day') as day_of_week,
       date_visited,
       n_users
FROM   ranked_counts
WHERE  rn < 3



-- NOTE: solved on first attempt