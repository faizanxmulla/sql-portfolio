SELECT query_name, ROUND(AVG(rating / position),2) AS quality, ROUND(AVG(rating < 3) * 100, 2) AS poor_query_percentage

FROM Queries 
WHERE query_name IS NOT NULL
GROUP BY 1


# use of "IF" clause instead of "CASE, WHEN, THEN, ELSE, END"--> to remember 

# update : 
# use : ROUND(AVG(rating < 3) * 100, 2) AS poor_query_percentage --- 
# instead of "IF" clause i.e. ROUND(SUM(IF(rating<3,1,0)) / COUNT(*) *100, 2)