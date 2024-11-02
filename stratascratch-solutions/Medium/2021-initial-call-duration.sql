WITH CTE as (
    SELECT request_id, 
           call_duration,
           created_on,
           MIN(created_on) OVER(PARTITION BY request_id) as initial_call
    FROM   redfin_call_tracking
)
SELECT AVG(call_duration)
FROM   CTE
WHERE  created_on=initial_call



-- note: in the first attempt, didnt perform the WHERE condition.