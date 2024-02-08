-- Assume you're given a table containing job postings from various companies on the LinkedIn platform. Write a query to retrieve the count of companies that have posted duplicate job listings.

-- Definition:
-- Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.


-- Solution 1 : using subquery 

SELECT Count(DISTINCT company_id) AS duplicate_companies
FROM   (SELECT   company_id,
                 title,
                 description,
                 Count(job_id) AS job_count
        FROM     job_listings
        GROUP BY 1,2,3) cte
WHERE  job_count > 1 


-- Solution 2 : using CTE

WITH CTE AS (
        SELECT   company_id,
                 title,
                 description,
                 Count(job_id) AS job_count
        FROM     job_listings
        GROUP BY 1, 2, 3
)

SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM   CTE
WHERE  job_count > 1;



-- Solution 3 : more similar to my approach

SELECT COUNT(DISTINCT company_id) as duplicate_companies
FROM   job_listings a JOIN job_listings b USING(company_id)
WHERE  a.job_id <> b.job_id AND a.title=b.title AND a.description=b.description;



-- first approach : 

SELECT COUNT(DISTINCT a.job_id) as duplicate_companies
FROM   job_listings a, job_listings b
WHERE  a.description = b.description