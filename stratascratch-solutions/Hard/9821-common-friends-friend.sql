SELECT   a.user_id, COUNT(DISTINCT c.friend_id)
FROM     google_friends_network a JOIN google_friends_network b ON a.friend_id = b.user_id
                                  JOIN google_friends_network c ON b.friend_id = c.friend_id AND 
                                                                  a.user_id = c.user_id
WHERE    a.friend_id != c.friend_id
GROUP BY 1