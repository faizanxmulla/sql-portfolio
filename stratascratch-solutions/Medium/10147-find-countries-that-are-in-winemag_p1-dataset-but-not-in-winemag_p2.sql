SELECT   distinct a.country
FROM     winemag_p1 a LEFT JOIN winemag_p2 b ON a.country=b.country
WHERE    b.country IS NULL
ORDER BY a.country