SELECT   movie, COUNT(nominee) as n_occurences
FROM     oscar_nominees
GROUP BY movie, year
ORDER BY n_occurences desc