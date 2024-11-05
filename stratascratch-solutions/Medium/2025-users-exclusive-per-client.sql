WITH CTE as (
    SELECT   user_id, COUNT(DISTINCT client_id)
    FROM     fact_events
    GROUP BY 1
    HAVING   COUNT(DISTINCT client_id) = 1
)
SELECT   fe.client_id, COUNT(DISTINCT fe.user_id)
FROM     CTE c JOIN fact_events fe ON c.user_id=fe.user_id
GROUP BY 1


-- NOTE: wasn't using DISTINCT initially.