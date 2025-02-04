SELECT   title, points, price, points/price as points_price_ratio
FROM     winemag_p2
WHERE    price IS NOT NULL
ORDER BY points_price_ratio desc
LIMIT    1