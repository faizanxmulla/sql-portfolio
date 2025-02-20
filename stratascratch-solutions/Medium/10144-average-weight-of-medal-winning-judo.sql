SELECT   team, AVG(weight) as average_player_weight
FROM     olympics_athletes_events
WHERE    age BETWEEN 20 and 30 
         and sport='Judo'
GROUP BY team