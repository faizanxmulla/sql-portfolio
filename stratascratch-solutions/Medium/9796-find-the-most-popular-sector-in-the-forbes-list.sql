SELECT   sector, COUNT(company) as n_companies
FROM     forbes_global_2010_2014
GROUP BY sector
ORDER BY COUNT(company) desc
LIMIT    1