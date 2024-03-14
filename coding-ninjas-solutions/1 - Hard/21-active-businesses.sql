-- The average activity for a particular event_type is the average occurences across all companies that have this event.
-- An active business is a business that has more than one event_type such that their occurences is strictly greater than the average activity for that event.

-- Write an SQL query to find all active businesses.


WITH CTE as (
    SELECT *, AVG(occurences) OVER(PARTITION BY event_type) as average_activity
    FROM   Events
)

SELECT   business_id
FROM     CTE
WHERE    occurences > average_activity
GROUP BY 1
HAVING   COUNT(event_type) > 1


-- remarks: solved on own; but with many iterations.