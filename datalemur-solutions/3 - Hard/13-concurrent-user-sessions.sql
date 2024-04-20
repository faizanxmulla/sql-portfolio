-- Assume you're given a table containing information about user sessions, including the start and end times of each session. Write a query to retrieve the user session(s) that occur concurrently with the other user sessions.

-- Output the session ID and the number of concurrent user sessions, sorted in descending order.

-- Assumptions:

-- Concurrent sessions are defined as sessions that overlap with each other. For instance, if session 1 starts before session 2, session 2's start time should fall either before or after session 1's end time.

-- Sessions with identical start and end times should not be considered concurrent sessions.


-- sessions Table:

-- Column Name	Type
-- session_id	integer
-- start_time	datetime
-- end_time	datetime


-- sessions 
-- Example Input:
-- session_id	start_time	end_time
-- 746382	01/02/2024 12:00:00	02/01/2024 16:48:00
-- 143145	01/02/2024 14:25:00	02/01/2024 15:05:00
-- 134514	01/02/2024 15:23:00	02/01/2024 18:15:00
-- 242354	01/02/2024 21:34:00	03/01/2024 00:11:00
-- 143256	01/06/2024 06:55:00	01/06/2024 09:05:00


-- Example Output:
-- session_id	concurrent_sessions
-- 746382	2
-- 143256	1

-- Session 746382 has 2 concurrent sessions: session_id 134514 and 242354.

-- Session 746382 ends at 02/01/2024 16:48:00, which is before session 134514's end time of 02/01/2024 18:15:00.

-- Additionally, session 746382 ends before session 242354's end time of 03/01/2024 00:11:00.

-- These comparisons indicate that session 746382 overlaps with both sessions 134514 and 242354 since its end time is earlier than the end times of both concurrent sessions.



SELECT   s1.session_id, 
         COUNT(s2.session_id) AS concurrent_sessions 
FROM     sessions AS s1 JOIN sessions AS s2  ON s1.session_id != s2.session_id
            AND (s2.start_time BETWEEN s1.start_time AND s1.end_time
            OR s1.start_time BETWEEN s2.start_time AND s2.end_time)
GROUP BY 1
ORDER BY 2 DESC;



-- remarks: was not following the second condition of --> OR s1.start_time BETWEEN s2.start_time AND s2.end_time



-- note: found this premium question here : https://datalemur.com/blog/pinterest-sql-interview-questions