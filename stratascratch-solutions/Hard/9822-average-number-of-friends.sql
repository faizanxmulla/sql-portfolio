SELECT AVG(t2.num_friends) as avg_num_friends_per_user
FROM (
     SELECT t1.user,
            COUNT(friend) as num_friends
     FROM (
        SELECT user_id as user,
               friend_id as friend
        FROM   google_friends_network
        UNION
        SELECT   friend_id as user, 
                 user_id as friend
        FROM     google_friends_network
        ) t1
        GROUP BY 1
    ) t2;