WITH ranked_posts as (
    SELECT channel_id, 
           post_id, 
           created_at, 
           likes,
           RANK() OVER(PARTITION BY channel_id ORDER BY likes desc) as rn
    FROM   posts
    WHERE  likes > 0
)
SELECT c.channel_name, r.post_id, r.created_at, r.likes
FROM   ranked_posts r JOIN channels c ON r.channel_id=c.channel_id
WHERE  r.rn <= 3