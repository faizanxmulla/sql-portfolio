WITH wine_tasting AS (
    SELECT   taster_name, 
             variety,
             RANK() OVER(PARTITION BY taster_name ORDER BY COUNT(*) DESC) AS rn
    FROM     winemag_p2
    WHERE    taster_name IS NOT NULL
    GROUP BY 1, 2
)
SELECT   taster_name, variety
FROM     wine_tasting
WHERE    rn=1
ORDER BY 1