SELECT   from_user, AVG(age) as average_age
FROM     airbnb_reviews r JOIN airbnb_guests g ON r.to_user = g.guest_id
WHERE    from_type = 'host'
GROUP BY from_user