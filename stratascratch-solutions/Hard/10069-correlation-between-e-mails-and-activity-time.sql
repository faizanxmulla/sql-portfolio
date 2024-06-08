-- Solution 1: (using CORR function)

WITH required_data AS (
    SELECT   e.day, 
             COUNT(id) AS total_received_emails, 
             COUNT(DISTINCT session_id) AS total_exercise
    FROM     google_gmail_emails e JOIN google_fit_location l USING(day)
    GROUP BY 1
    ORDER BY 1
)
SELECT CORR(total_received_emails, total_exercise) AS correlation
FROM   required_data
