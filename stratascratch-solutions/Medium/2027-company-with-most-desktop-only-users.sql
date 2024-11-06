WITH filtered_users AS (
    SELECT   user_id
    FROM     fact_events
    GROUP BY 1
    HAVING   COUNT(DISTINCT client_id) = 1
),
ranked_customers AS (
    SELECT   customer_id,
             RANK() OVER (ORDER BY COUNT(DISTINCT user_id) DESC) as rn
    FROM     fact_events
    WHERE    user_id IN (SELECT user_id FROM filtered_users) 
             and client_id = 'desktop'
    GROUP BY 1
)
SELECT customer_id
FROM   ranked_customers
WHERE  rn = 1



-- NOTE: couldn't solve on own. lot tougher than it looks at first glance.