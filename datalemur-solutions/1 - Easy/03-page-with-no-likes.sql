-- Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

-- Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.


-- Solution 1 : using NOT IN. (my approach)

SELECT page_id
FROM   pages
WHERE  page_id NOT IN (SELECT page_id
                       FROM   pages_likes
                       WHERE  page_id IS NOT NULL) 


-- Solution 2: using NOT EXISTS

SELECT page_id
FROM   pages
WHERE  NOT EXISTS (SELECT page_id
                   FROM   page_likes AS likes
                   WHERE  likes.page_id = pages.page_id) 


-- Solution 3 : using Joins (my initial approach)

SELECT pages.page_id
FROM   pages
       LEFT OUTER JOIN page_likes AS likes
                    ON pages.page_id = likes.page_id
WHERE  likes.page_id IS NULL; 


-- Solution 4 : kind of ingenius. 

SELECT page_id
FROM   pages
EXCEPT
SELECT page_id
FROM   page_likes;



-- first approach : 

SELECT   page_id
FROM     pages p INNER JOIN page_likes pl ON p.page_id=pl.page_id
WHERE    COUNT(pl.page_id) = 0
ORDER BY 1 

-- REMARKS : 
-- 1. saw 2 tables given, and immediately went to join them w/o thinking. could be more easily solved w/o joins.
-- 2. to remember use of : EXCEPT & INTERSECT.