SELECT   ps.page_id as page, 
         ps.postal_code, 
         1.0 * COUNT(CASE WHEN ps.postal_code = u.postal_code THEN r.user_id ELSE null END) / 
               COUNT(r.user_id) as percentage
FROM     page_sponsorships ps JOIN recommendations r ON ps.page_id=r.page_id 
                              JOIN users u ON r.user_id=u.id
GROUP BY 1, 2
ORDER BY 1


-- my attempt:

SELECT   ps.page_id, ps.postal_code, ROUND(1.0 * COUNT(user_id) / COUNT(*) OVER(), 1) as percentage
FROM     page_sponsorships ps JOIN recommendations r ON ps.page_id=r.page_id 
                              JOIN users u ON r.user_id=u.id and ps.postal_code=u.postal_code
GROUP BY 1, 2



-- NOTE: 

-- was using postal_code condition in the join itself, which was a mistake. 
-- also had to drop ROUND() function to pass second test case.