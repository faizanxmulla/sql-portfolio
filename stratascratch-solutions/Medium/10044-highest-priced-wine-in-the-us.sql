SELECT   variety, MAX(price)
FROM     winemag_p1
GROUP BY variety
HAVING   MIN(points) >= 90
         and MAX(CASE WHEN country = 'US' THEN 1 ELSE 0 END) = 1
         and MAX(CASE WHEN country IN ('Spain', 'Argentina') THEN 1 ELSE 0 END) = 0