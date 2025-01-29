SELECT   reviewer_nationality, COUNT(negative_review) as n_negative_reviews
FROM     hotel_reviews
WHERE    negative_review <> 'No Negative'
GROUP BY reviewer_nationality
ORDER BY n_negative_reviews desc