-- Solution 1: using CASE WHEN statements

SELECT *
FROM   user_flags
WHERE  ((CASE WHEN user_firstname IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN user_lastname IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN video_id IS NULL THEN 1 ELSE 0 END) + 
        (CASE WHEN flag_id IS NULL THEN 1 ELSE 0 END)) >= 2



-- Solution 2: using NUM_NULLS

SELECT *
FROM   user_flags
WHERE  num_nulls(user_firstname, user_lastname, video_id, flag_id) >= 2