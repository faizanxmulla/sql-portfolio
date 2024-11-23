WITH get_calls as (
    SELECT caller_id, 
           date_called,
           FIRST_VALUE(recipient_id) OVER(PARTITION BY caller_id, DATE(date_called) ORDER BY date_called) as first_call,
           FIRST_VALUE(recipient_id) OVER(PARTITION BY caller_id, DATE(date_called) ORDER BY date_called desc) as last_call
    FROM   caller_history
)
SELECT   caller_id,
         first_call as recipient,
         DATE(date_called)
FROM     get_calls
WHERE    first_call=last_call
GROUP BY 1, 2, 3




-- NOTE: didn't convert to date, so got the wrong answer at first. also initially was using MIN and MAX which turned out to be lengthy.