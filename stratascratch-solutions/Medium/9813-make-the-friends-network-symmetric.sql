SELECT user_id, friend_id
FROM   google_friends_network
UNION
SELECT friend_id, user_id
FROM   google_friends_network