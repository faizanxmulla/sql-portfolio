WITH CTE as (
	SELECT   u.id, COUNT(c.user_id) as comment_count
	FROM     users u LEFT JOIN comments c 
    ON       u.id = c.user_id
	         and c.created_at BETWEEN '2020-01-01' AND '2020-01-31'
	GROUP BY u.id
)
SELECT   comment_count, COUNT(*) as frequency
FROM     CTE
GROUP BY comment_count




-- my initial attempt
-- should have just used LEFT JOIN

WITH CTE as (
    SELECT *, 
           CASE 
                WHEN created_at BETWEEN '2020-01-01' and '2020-01-31' 
                THEN 'yes' 
                ELSE 'no' 
           END as to_consider
    FROM   comments 
)
,cte_2 as (
    SELECT   u.id, COUNT(body) FILTER(WHERE to_consider='yes') as yes_count
    FROM     CTE c JOIN users u ON c.user_id=u.id
    GROUP BY u.id
)
SELECT   yes_count, COUNT(*) as frequency
FROM     cte_2
GROUP BY yes_count
ORDER BY yes_count



-- NOTE: query doesn't work where the month condition is in the WHERE clause. have to put it in the JOIN condition itself.