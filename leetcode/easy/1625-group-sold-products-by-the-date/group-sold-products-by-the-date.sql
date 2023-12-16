SELECT sell_date, COUNT(DISTINCT product ) as num_sold, GROUP_CONCAT(DISTINCT product) as products
FROM Activities 
GROUP BY 1
ORDER BY 1


# new learning : GROUP_CONCAT() --> default separator is ",".