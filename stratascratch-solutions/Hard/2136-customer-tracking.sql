WITH active_hours_cte AS (
    SELECT cust_id, 
           state,
           LEAD(timestamp) OVER(PARTITION BY cust_id ORDER BY timestamp)::time - 
           timestamp::time AS active_seconds
    FROM   cust_tracking
)
SELECT   cust_id, SUM(active_seconds) / 3600 AS active_hours
FROM     active_hours_cte
WHERE    state=1
GROUP BY 1