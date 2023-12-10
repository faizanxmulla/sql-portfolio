SELECT contest_id, ROUND(COUNT(user_id)/ (SELECT COUNT(user_id) FROM Users)* 100,2) as percentage
FROM Register
GROUP BY 1
ORDER BY 2 DESC, 1


# moving "* 100" outside decreases the runtime --> good thing.