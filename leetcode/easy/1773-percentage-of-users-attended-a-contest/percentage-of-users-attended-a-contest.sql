SELECT contest_id, ROUND(COUNT(DISTINCT user_id)/ (SELECT COUNT(user_id) FROM Users)* 100,2) as percentage
FROM Register
GROUP BY 1
ORDER BY 2 DESC, 1


# 1. moving "* 100" outside decreases the runtime --> good thing.
# 2. removing DISTINCT doesn't help.