WITH CTE as (
    SELECT   user_id,
             SUM(CASE WHEN (channel = 'facebook' OR channel = 'google') THEN 1 ELSE 0 END) AS paid_count
    FROM     user_sessions us LEFT JOIN attribution a ON us.session_id=a.session_id
    GROUP BY user_id
)
SELECT user_id,
       CASE WHEN paid_count >=1 THEN 'paid' ELSE 'organic' END as attribute
FROM   CTE



-- NOTE: 

-- still not passing the 2nd testcase; referred the comments as well as the solutions section.
