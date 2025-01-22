-- Metric Definition:

-- The percentage of upvotes a voter gives to a particular commenter (relative to all their upvotes). If this percentage is greater than or equal to 60% (perc >= 0.6), the voter might be considered as exhibiting fraudulent behavior.



WITH percentage_cte as (
    SELECT   v.user_id as voter_id,
             c.user_id as commenter_id,
             COUNT(comment_id) * 1.0 / SUM(COUNT(comment_id)) OVER (PARTITION BY v.user_id) as perc
    FROM     comment_votes v JOIN comments c ON v.comment_id = c.id
    WHERE    is_upvote = 1
    GROUP BY v.user_id, c.user_id
)
SELECT   p.voter_id,
         u.username as voter,
         p.commenter_id,
         u1.username as commenter,
         ROUND(perc * 100, 2) as vote_perc
FROM     percentage_cte p LEFT JOIN users u ON p.voter_id = u.id
                          LEFT JOIN users u1 ON p.commenter_id = u1.id
WHERE    perc >= 0.6
ORDER BY vote_perc desc



-- NOTE: 

-- couldn't solve on my own; 
-- couldn't understand the question fully; 
-- note to get good at these kinds of subjective questions