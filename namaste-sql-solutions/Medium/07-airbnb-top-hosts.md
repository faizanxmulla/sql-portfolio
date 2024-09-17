![image](https://github.com/user-attachments/assets/293c3a74-ce52-449c-b120-d3d90bc75b6e)



### Solution Query

```sql
-- hosts with highest avg listings --> ROW_NUMBER()
-- top 2 hosts --> rn <= 2
-- listing_count > 2


-- Solution 1: my solution

SELECT   host_id, COUNT(DISTINCT listing_id) as no_of_listings, ROUND(AVG(rating), 2) as avg_rating
FROM     listings l JOIN reviews r USING(listing_id)
WHERE    host_id IN (
  			SELECT   host_id
			FROM     listings
			GROUP BY 1
			HAVING   COUNT(listing_id) >= 2
  		)
GROUP BY 1
ORDER BY 3 DESC
LIMIT    2


-- Solution 2: using CTE

WITH listing_count AS (
    SELECT host_id, listing_id, COUNT(*) OVER (PARTITION BY host_id) AS no_of_listings
    FROM listings
)
SELECT   lc.host_id,
         no_of_listings,
         ROUND(AVG(rating), 2) AS avg_rating
FROM     listing_count lc JOIN reviews r USING(listing_id)
WHERE    no_of_listings >= 2
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT    2
```