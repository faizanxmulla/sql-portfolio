WITH top_ads as (
    SELECT id
    FROM   ads 
    LIMIT  3
)
SELECT 'inner_join' as join_type, COUNT(*) as number_of_rows
FROM   ads a INNER JOIN top_ads ta ON a.id=ta.id
UNION ALL
SELECT 'left_join', COUNT(*)
FROM   ads a LEFT JOIN top_ads ta ON a.id=ta.id
UNION ALL
SELECT 'right_join', COUNT(*)
FROM   ads a RIGHT JOIN top_ads ta ON a.id=ta.id
UNION ALL
SELECT 'cross_join', COUNT(*)
FROM   ads CROSS JOIN top_ads



-- NOTE: solved on first attempt