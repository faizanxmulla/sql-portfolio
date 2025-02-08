SELECT   business_id, SUM(checkins) as n_checkins
FROM     yelp_checkin
GROUP BY business_id
ORDER BY n_checkins desc
LIMIT    5