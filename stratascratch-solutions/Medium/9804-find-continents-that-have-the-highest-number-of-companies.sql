SELECT   continent, COUNT(company) as n_companies
FROM     forbes_global_2010_2014
GROUP BY continent
ORDER BY n_companies desc
LIMIT    1