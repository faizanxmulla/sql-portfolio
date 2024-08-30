WITH CTE AS (
    SELECT a1.date
           ,ROUND((3 * a1.new_users + 2 * IFNULL(a2.new_users, 0) + 1 * IFNULL(a3.new_users, 0)) / 6, 2) AS weighted_average
           ,RANK() OVER(ORDER BY a1.date) AS rank
    FROM   acquisitions a1 LEFT JOIN acquisitions a2 ON a1.date = a2.date + 1
                           LEFT JOIN acquisitions a3 ON a1.date = a3.date + 2
)
SELECT date, weighted_average
FROM   CTE
WHERE  rank > 2