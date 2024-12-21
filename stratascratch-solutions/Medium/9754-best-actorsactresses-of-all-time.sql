SELECT   nominee, COUNT(*) as n_occurences
FROM     oscar_nominees
WHERE    winner='TRUE'
GROUP BY nominee
ORDER BY n_occurences desc