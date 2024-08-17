SELECT   s1.user_id, 
         MIN(CASE WHEN s2.user_id IS NOT NULL THEN 1 ELSE 0 END) as overlap
FROM     subscriptions s1 LEFT JOIN subscriptions s2 
ON       s1.user_id != s2.user_id AND 
         s1.start_date <= s2.end_date AND
         s1.end_date >= s2.start_date
GROUP BY 1