SELECT   h.nationality, SUM(n_beds) as total_beds_available
FROM     airbnb_apartments a JOIN airbnb_hosts h ON a.host_id=h.host_id
GROUP BY nationality
ORDER BY total_beds_available desc