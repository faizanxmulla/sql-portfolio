with ranked_logins as (
    SELECT *, RANK() OVER(PARTITION BY player_id ORDER BY event_date) 
    FROM   Activity
)
SELECT player_id, event_date as first_login
FROM   ranked_logins
WHERE  rank=1


-- remarks: solved on first attempt.