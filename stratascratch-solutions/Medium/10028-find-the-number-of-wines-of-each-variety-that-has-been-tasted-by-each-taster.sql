SELECT   taster_name, variety, COUNT(*) as n_tastings
FROM     winemag_p2
WHERE    taster_name IS NOT NULL
GROUP BY taster_name, variety
ORDER BY taster_name, variety, n_tastings desc