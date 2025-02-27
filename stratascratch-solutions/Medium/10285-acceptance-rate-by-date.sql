SELECT   s.date,
         1.0 * COUNT(distinct a.user_id_sender || '-' || a.user_id_receiver) / 
               COUNT(distinct s.user_id_sender || '-' || s.user_id_receiver) as acceptance_rate
FROM     fb_friend_requests as s LEFT JOIN fb_friend_requests as a
ON       s.user_id_sender = a.user_id_sender
         and s.user_id_receiver = a.user_id_receiver
         and a.action = 'accepted'
         and a.date >= s.date
WHERE    s.action = 'sent'
GROUP BY s.date
HAVING   COUNT(distinct a.user_id_sender || '-' || a.user_id_receiver) > 0
ORDER BY s.date



-- NOTE: couldn't solve on own; good question