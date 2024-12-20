SELECT   pd_district, COUNT(distinct incidnt_num) as n_occurences
FROM     sf_crime_incidents_2014_01
GROUP BY pd_district
ORDER BY n_occurences desc