-- From users who had their first session as a viewer, how many streamer sessions have they had? 

-- Return the user id and number of sessions in descending order. 
-- In case there are users with the same number of sessions, order them by ascending user id.

-- Tables <twitch_sessions>:

-- user_id                     int
-- session_start               datetime
-- session_end                 datetime
-- session_id                  int
-- session_type                varchar


WITH first_session_as_viewer AS(
    SELECT   user_id, MIN(session_start) as first_session
    FROM     twitch_sessions
    WHERE    session_type='viewer'
    GROUP BY 1
)
SELECT   ts.user_id, COUNT(*) AS count
FROM     first_session_as_viewer fs JOIN twitch_sessions ts USING(user_id)
WHERE    session_type='streamer' AND 
         ts.session_start > fs.first_session
GROUP BY 1
ORDER BY 2 DESC, 1