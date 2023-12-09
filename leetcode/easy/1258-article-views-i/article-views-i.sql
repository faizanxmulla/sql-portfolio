SELECT author_id as id
FROM Views 
WHERE viewer_id = author_id 
GROUP BY author_id
HAVING COUNT(article_id) >= 1
ORDER BY 1
