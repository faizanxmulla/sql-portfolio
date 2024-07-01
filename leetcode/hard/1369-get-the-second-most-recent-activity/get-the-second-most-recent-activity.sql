WITH ranked_activities AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY username ORDER BY startdate desc) AS rn,
           COUNT(*) OVER(PARTITION BY username) AS count
    FROM   UserActivity
)
SELECT username, activity, startdate, enddate
FROM   ranked_activities
WHERE  rn=2 OR count=1