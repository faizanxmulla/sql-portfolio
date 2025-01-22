SELECT COUNT(distinct id) as n_athletes
FROM   olympics_athletes_events
WHERE  city IN ('Berlin', 'Athina', 'Lillehammer', 'London', 'Albertville', 'Paris')