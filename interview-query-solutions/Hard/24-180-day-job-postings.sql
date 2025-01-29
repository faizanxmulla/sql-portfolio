WITH get_most_recent_posting as (
    SELECT *, 
           MAX(date_posted) OVER() as most_recent_date,
           ROW_NUMBER() OVER(PARTITION BY job_id ORDER BY date_posted desc) as rn
    FROM   job_postings
)
SELECT ROUND(100.0 * SUM(is_revoked) / COUNT(*), 2) as percentage
FROM   get_most_recent_posting
WHERE  rn=1
       and date_posted >= DATE_SUB(most_recent_date, INTERVAL 180 DAY)



-- NOTE: solved by self; initially was messing up as had to use MySQL instead of Postgres.