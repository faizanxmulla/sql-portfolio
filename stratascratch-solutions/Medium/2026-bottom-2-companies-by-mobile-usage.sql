WITH ranked_mobile_events as (
    SELECT   customer_id, 
             COUNT(event_id) as count,
             RANK() OVER(ORDER BY COUNT(event_id)) as rn
    FROM     fact_events
    WHERE    client_id='mobile'
    GROUP BY 1
)
SELECT customer_id, count
FROM   ranked_mobile_events
WHERE  rn=1