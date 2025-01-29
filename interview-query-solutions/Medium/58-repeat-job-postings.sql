WITH CTE as (
    SELECT   user_id, 
             COUNT(distinct job_id) as n_jobs,
             COUNT(distinct id) as n_posts
    FROM     job_postings
    GROUP BY user_id
)
SELECT SUM(CASE WHEN n_jobs=n_posts THEN 1 ELSE 0 END) as single_post,
       SUM(CASE WHEN n_jobs <> n_posts THEN 1 ELSE 0 END) as multiple_posts
FROM   CTE