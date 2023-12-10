SELECT contest_id, ROUND(COUNT(DISTINCT user_id) *100 / (SELECT COUNT(user_id) FROM Users),2) as percentage
FROM Register
GROUP BY 1
ORDER BY 2 DESC, 1

