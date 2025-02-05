WITH combined_wines_corpus as (
    SELECT province, id, 'p1' as dataset
    FROM   winemag_p1
    UNION ALL
    SELECT province, id, 'p2'
    FROM   winemag_p2
),
wine_counts as (
    SELECT   province, 
             COUNT(CASE WHEN dataset = 'p1' THEN id END) as p1_count,
             COUNT(CASE WHEN dataset = 'p2' THEN id END) as p2_count
    FROM     combined_wines_corpus
    GROUP BY province
)
SELECT   province, p1_count
FROM     wine_counts
WHERE    p1_count > p2_count
ORDER BY p1_count desc