SELECT   u.name as customer_name
FROM     transactions t JOIN users u ON t.user_id=u.id
GROUP BY 1
HAVING   COUNT(t.id) FILTER(WHERE EXTRACT(YEAR FROM created_at)='2019') >= 3
         and COUNT(t.id) FILTER(WHERE EXTRACT(YEAR FROM created_at)='2020') >= 3



-- NOTE: solved on first attempt; also can use 'CASE WHEN' instead of FILTER clause.