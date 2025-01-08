SELECT   hotel_name, COUNT(negative_review) as n_negative_reviews
FROM     hotel_reviews
WHERE    negative_review <> 'No Negative'
GROUP BY hotel_name
ORDER BY n_negative_reviews desc
LIMIT    2



-- NOTE: can alternatively use the RANK() function too.