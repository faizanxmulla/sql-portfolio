SELECT   u.id, 
         u.username, 
         COUNT(is_upvote) AS upvotes
FROM     comments c JOIN comment_votes cv ON c.id = cv.comment_id and c.user_id != cv.user_id
                    JOIN users u ON c.user_id = u.id
WHERE    c.created_at BETWEEN '2020-01-01' and '2020-12-31'
         and is_upvote='TRUE'
         and is_deleted='FALSE'
         and cv.user_id != c.user_id
GROUP BY 1, 2
ORDER BY 3 desc
LIMIT    3



-- my initial attempt:

-- WITH get_valid_upvotes as (
--     SELECT c.user_id, 
--            c.id, 
--            c.post_id, 
--            CASE WHEN cv.is_upvote='TRUE' THEN 1 ELSE 0 END as is_upvote
--     FROM   comment_votes cv JOIN comments c ON cv.comment_id=c.id
--     WHERE  c.created_at BETWEEN '2020-01-01' and '2020-12-31'
--            and is_upvote='TRUE'
--            and is_deleted='FALSE'
--            and cv.user_id != c.user_id
-- )
-- SELECT   u.username, vu.id, SUM(is_upvote) OVER(PARTITION BY u.username) as upvotes
-- FROM     users u JOIN get_valid_upvotes vu ON u.id=vu.user_id
-- ORDER BY 3 desc



-- NOTE: unnecessarily complicated it.