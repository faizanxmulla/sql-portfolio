-- Print the genre and the maximum net profit among all the movies of that genre released in 2012 per genre. (Download the dataset from console)

-- Note:
-- 1. Do not print any row where either genre or the net profit is empty/null.
-- 2. net_profit = Domestic + Worldwide - Budget
-- 3. Keep the name of the columns as 'genre' and 'net_profit'
-- 4. The genres should be printed in alphabetical order.


SELECT   g.genre, 
         MAX(e.Domestic + e.Worldwide - i.Budget) as net_profit
FROM     IMDB i JOIN earning e USING(Movie_id)  
                JOIN genre g USING(Movie_id)
WHERE    i.Title LIKE '%2012%' AND genre IS NOT NULL
GROUP BY 1
ORDER BY 1



-- my approach: 

SELECT   g.genre, 
         SUM(e.Domestic + e.Worldwide) - i.Budget as net_profit
FROM     IMDB i JOIN earning e USING(Movie_id)  
                JOIN genre g USING(Movie_id)
WHERE    i.Title LIKE '%2012%' AND net_profit IS NOT NULL
ORDER BY 1


-- remarks: didnt read the question properly --> MAX net profit, per genre.
-- ERROR: "net_profit" column does not exist.