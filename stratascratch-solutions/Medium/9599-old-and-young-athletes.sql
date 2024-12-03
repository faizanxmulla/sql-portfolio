SELECT   games,
         COUNT(distinct id) FILTER(WHERE age >= 50) as sum,
         COUNT(distinct id) FILTER(WHERE age <= 25) as sum,
         1.0 * COUNT(distinct id) FILTER(WHERE age >= 50) / COUNT(distinct id) FILTER(WHERE age <= 25) as old_to_young_ratio
FROM     olympics_athletes_events
GROUP BY games



-- NOTE: solved on second attempt; wasn't using DISTINCT in the first one.