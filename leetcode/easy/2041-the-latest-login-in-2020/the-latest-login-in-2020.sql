WITH ranked_timestamps AS (
    SELECT user_id, 
           time_stamp,
           RANK() OVER(PARTITION BY user_id ORDER BY time_stamp DESC) AS rn
    FROM   Logins
    WHERE  EXTRACT(YEAR FROM time_stamp)='2020'
)
SELECT user_id, time_stamp AS last_stamp
FROM   ranked_timestamps
WHERE  rn=1


-- approach 2: more simple & straightforward.

-- SELECT   user_id, MAX(time_stamp) AS last_stamp
-- FROM     Logins
-- WHERE    EXTRACT(YEAR FROM time_stamp)='2020'
-- GROUP BY 1