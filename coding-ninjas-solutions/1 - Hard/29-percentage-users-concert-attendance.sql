-- Write an SQL query to find the percentage of the users registered in each contest rounded to two decimals.

-- Return the result table ordered by percentage in descending order. 
-- In case of a tie, order it by contest_id in ascending order.


SELECT   contest_id, 
         ROUND((COUNT(user_id) / (SELECT COUNT(*) FROM Users)) * 100, 2) as percentage
FROM     Register
GROUP BY 1
ORDER BY 2 DESC, 1



-- remarks: was messing up this part --> SELECT COUNT(*) FROM Users


