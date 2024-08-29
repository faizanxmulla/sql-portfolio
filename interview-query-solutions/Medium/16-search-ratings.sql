WITH CTE as ( 
    SELECT *, rating/position::decimal as calc 
    FROM   search_results 
) 
SELECT   query, ROUND(AVG(calc), 2) as avg_rating 
FROM     CTE 
GROUP BY 1


-- NOTE: peculiar type of problem.