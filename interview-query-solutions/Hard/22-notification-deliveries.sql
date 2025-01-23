WITH CTE as (
    SELECT   u.id, COUNT(nd.notification) as total_pushes
    FROM     users u LEFT JOIN notification_deliveries nd 
    ON       u.id=nd.user_id and nd.created_at <= u.conversion_date
    WHERE    u.conversion_date IS NOT NULL
    GROUP BY u.id
)
SELECT   total_pushes, COUNT(*) as frequency
FROM     CTE
GROUP BY total_pushes



-- NOTE:

-- 1. when this condition 'nd.created_at <= u.conversion_date' in tHE WHERE clause, it doen't works.

-- 2. earlier I was trying this condition: 'nd.created_at BETWEEN u.created_at and u.conversion_date'