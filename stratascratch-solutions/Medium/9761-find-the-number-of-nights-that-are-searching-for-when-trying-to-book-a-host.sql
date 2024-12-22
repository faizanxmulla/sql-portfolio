SELECT   n_nights, SUM(n_searches) as total_searches
FROM     airbnb_searches
GROUP BY n_nights
ORDER BY total_searches desc