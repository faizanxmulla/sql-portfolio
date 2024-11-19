SELECT   video_id, 
         COUNT(DISTINCT CONCAT(user_firstname, ' ', user_lastname)) as num_unique_users
FROM     user_flags
WHERE    flag_id IS NOT NULL
GROUP BY video_id



-- NOTE: solved on first attempt