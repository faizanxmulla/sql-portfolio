SELECT   reviewer_nationality, COUNT(positive_review) as n_positive_reviews
FROM     hotel_reviews
WHERE    positive_review <> 'No Positive'
GROUP BY reviewer_nationality
ORDER BY n_positive_reviews desc