WITH recipes_corpus AS (
    SELECT grocery, mass 
    FROM   recipe1
    UNION ALL
    SELECT grocery, mass 
    FROM   recipe2
    UNION ALL
    SELECT grocery, mass 
    FROM   recipe3
)
SELECT   grocery, SUM(mass) as total_mass
FROM     recipes_corpus
GROUP BY 1