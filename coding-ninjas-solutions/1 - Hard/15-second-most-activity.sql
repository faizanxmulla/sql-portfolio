-- Write an SQL query to show the second most recent activity of each user.

-- If the user only has one activity, return that one. 



WITH rankedActivities as(
    SELECT *, RANK() OVER(PARTITION BY username ORDER BY endDate DESC) as rank
    FROM   UserActivity
)

SELECT username, activity, startDate, endDate
FROM   rankedActivities
WHERE  rank=2 or 
       username = (SELECT   username
                   FROM     UserActivity
                   GROUP BY 1
                   HAVING   COUNT(*) = 1 )



-- my approach: 

WITH rankedActivities as(
    SELECT *, RANK() OVER(PARTITION BY username ORDER BY endDate DESC) as rank
    FROM   UserActivity
)

SELECT username, activity, startDate, endDate
FROM   rankedActivities
WHERE  rank=2



-- remarks: couldn't figure out the part where there is a single entry. 