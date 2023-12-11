SELECT activity_date as day, COUNT(DISTINCT user_id) as active_users
FROM Activity 
GROUP BY 1
HAVING activity_date BETWEEN '2019-06-28' AND '2019-07-27'


# different ways to handle date condition : 

# 1. HAVING activity_date >= DATE_SUB('2019-07-27', INTERVAL 30 DAY)
# 2. WHERE (datediff('2019-7-27',activity_date) <= 30)
# 3. WHERE (activity_date > "2019-06-27" AND activity_date <= "2019-07-27")
# 4. WHERE DATEDIFF('2019-07-27', activity_date) < 30
# 5. WHERE DATEDIFF("2019-07-27", activity_date) BETWEEN 0 AND 29
# 6. WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'
