SELECT   LENGTH(SPLIT_PART(name, ' ', 1)) AS first_name_length,
         COUNT(name) FILTER (WHERE medal IS NULL),
         COUNT(name) FILTER (WHERE medal = 'Bronze'),
         COUNT(name) FILTER (WHERE medal = 'Silver'),
         COUNT(name) FILTER (WHERE medal = 'Gold')
FROM     olympics_athletes_events
GROUP BY 1