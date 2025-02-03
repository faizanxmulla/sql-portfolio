SELECT   winery, variety, SUM(price) as total_revenue
FROM     winemag_p1
GROUP BY winery, variety
HAVING   MIN(points) >= 90
ORDER BY winery, total_revenue desc



-- NOTE: didn't use the HAVING cluase initially, was using the WHERE condition.