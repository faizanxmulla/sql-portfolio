-- In facebook, there is a follow table with two columns: followee, follower.

-- Please write a sql query to get the amount of each follower’s follower if he/she has one.

SELECT   followee as follower, COUNT(follower) as num
FROM     follow
WHERE    followee IN (
    SELECT follower
    FROM   follow
)
GROUP BY 1


-- remarks: was trying "WHERE followee in follower".