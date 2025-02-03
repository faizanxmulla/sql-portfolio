SELECT   country, region_1, COUNT(distinct winery)
FROM     winemag_p1
WHERE    lower(winery) like '%bodega%'
         and lower(description) like '%blackberry%'
         and country <> 'Spain'
GROUP BY country, region_1