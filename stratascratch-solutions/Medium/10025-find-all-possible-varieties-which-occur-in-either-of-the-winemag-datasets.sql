SELECT variety
FROM   winemag_p1
UNION
SELECT variety
FROM   winemag_p2
ORDER BY variety



-- NOTE: no need to use DISTINCT or GROUP BY 