SELECT   industry, COUNT(company) as n_companies
FROM     forbes_global_2010_2014
GROUP BY industry
ORDER BY COUNT(company) desc
-- LIMIT    1