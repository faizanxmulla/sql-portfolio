SELECT COUNT(DISTINCT p.post_id) as n_posts_with_a_like
FROM   facebook_posts p JOIN facebook_reactions r 
ON     p.post_id = r.post_id and r.reaction = 'like'