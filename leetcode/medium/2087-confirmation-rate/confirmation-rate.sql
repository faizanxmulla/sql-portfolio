SELECT user_id, ROUND(AVG(IF(c.action = "confirmed", 1, 0)), 2) AS confirmation_rate
FROM Signups s LEFT JOIN Confirmations c USING(user_id)
GROUP BY 1 


# my first approach was to use : WHERE c.action = 'confirmed' --> doesn't work

# also can use : ROUND(AVG(CASE WHEN action = 'confirmed' THEN 1.00 ELSE 0.00 END),2)