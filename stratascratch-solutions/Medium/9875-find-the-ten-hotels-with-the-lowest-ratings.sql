WITH ranked_hotels as (
    SELECT   distinct hotel_name,
             average_score,
             RANK() OVER(ORDER BY average_score) as rn
    FROM     hotel_reviews
    WHERE    average_score IS NOT NULL
    GROUP BY hotel_name, average_score
)
SELECT   hotel_name, average_score
FROM     ranked_hotels
WHERE    rn <= 10



-- NOTE: exactly similar to #9874, just change to ORDER BY asc.