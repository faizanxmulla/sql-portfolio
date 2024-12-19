SELECT   category, COUNT(distinct incidnt_num) as n_occurences
FROM     sf_crime_incidents_2014_01
WHERE    date BETWEEN '2014-01-01' and '2014-12-31'
GROUP BY category
ORDER BY n_occurences desc



-- NOTE: didn't read the year condition initially