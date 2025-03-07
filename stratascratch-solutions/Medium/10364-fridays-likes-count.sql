SELECT   l.date_liked, COUNT(*) as likes
FROM     user_posts p JOIN likes l ON p.post_id=l.post_id
                      JOIN friendships f ON (p.user_name=f.user_name1 and l.user_name=f.user_name2) 
                                         or (p.user_name=f.user_name2 and l.user_name=f.user_name1)
WHERE    EXTRACT(DOW FROM l.date_liked) = 5
GROUP BY l.date_liked



-- NOTE: good question; remember for later (especially the join condition)