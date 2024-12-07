SELECT COALESCE(SUM(IF(ra.accepter_id IS NOT NULL, 1, 0)) / COUNT(*), 1) as acceptance_rate
FROM   friend_requests fr LEFT JOIN requests_accepted ra 
ON     fr.requester_id = ra.requester_id 
WHERE  CAST(fr.sent_at AS DATE) BETWEEN DATE_ADD('2022-07-02', INTERVAL -4 WEEK) and '2022-07-02'



-- NOTE: was not able to solve on my own. some doubt even after seeing the video solution