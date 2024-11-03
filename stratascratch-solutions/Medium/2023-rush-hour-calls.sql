WITH CTE as (
    SELECT   request_id
    FROM     redfin_call_tracking
    WHERE    EXTRACT(HOUR FROM created_on) BETWEEN 15 and 17
    GROUP BY 1
    HAVING   COUNT(*) >= 3
)
SELECT COUNT(request_id)
FROM   CTE