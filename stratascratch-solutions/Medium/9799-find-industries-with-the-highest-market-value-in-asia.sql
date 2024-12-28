SELECT   industry, SUM(marketvalue) as total_marketvalue
FROM     forbes_global_2010_2014
WHERE    continent='Asia'
GROUP BY industry
ORDER BY total_marketvalue desc
LIMIT    1



-- NOTE: solved on second attempt; didn't notice the Asia condition.